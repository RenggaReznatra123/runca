import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../utility/resource/data_state.dart';

abstract class BaseRepository {
  Future<DataState<T>> getStateOf<T>({
    required Future<HttpResponse<T>> Function() request,
  }) async {
    try {
      final response = await request();
      final statusCode = response.response.statusCode ?? 0;

      if (statusCode == 200 || statusCode == 201) {
        return DataStateSuccess<T>(response.data);
      }

      throw DioException(
        requestOptions: response.response.requestOptions,
        response: response.response,
        type: DioExceptionType.badResponse,
        message: 'Unexpected status code: $statusCode',
      );
    } on DioException catch (e, stackTrace) {
      await _reportToSentry(e, stackTrace);
      return DataStateError<T>(
        CleanDioException(
          url: e.requestOptions.path,
          method: e.requestOptions.method,
          message: _getCleanDioErrorMessage(e),
          statusCode: e.response?.statusCode,
          requestOptions: e.requestOptions,
          response: e.response,
          type: e.type,
          error: e.error,
        ),
      );
    } catch (e, stackTrace) {
      final fallback = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.unknown,
        message: e.toString(),
        error: e,
      );
      await _reportToSentry(fallback, stackTrace);
      return DataStateError<T>(
        CleanDioException(
          url: fallback.requestOptions.path,
          method: fallback.requestOptions.method,
          message: _getCleanDioErrorMessage(fallback),
          statusCode: fallback.response?.statusCode,
          requestOptions: fallback.requestOptions,
          response: fallback.response,
          type: fallback.type,
          error: fallback.error,
        ),
      );
    }
  }

  Future<void> _reportToSentry(
    DioException exception,
    StackTrace stackTrace,
  ) async {
    try {
      final endpoint = exception.requestOptions.path;
      final method = exception.requestOptions.method;
      final statusCode = exception.response?.statusCode;

      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('endpoint', endpoint);
          scope.setTag('method', method);
          scope.setTag('status_code', '${statusCode ?? 0}');

          scope.setContexts('http_request', <String, dynamic>{
            'url': exception.requestOptions.uri.toString(),
            'method': method,
            'query_parameters':
                exception.requestOptions.queryParameters.toString(),
          });
          scope.setContexts('http_response', <String, dynamic>{
            'status_code': statusCode,
            'data': '${exception.response?.data}'.substring(
              0,
              '${exception.response?.data}'.length > 2000
                  ? 2000
                  : '${exception.response?.data}'.length,
            ),
          });
          scope.setContexts(
            'auth_context',
            _authContextFromRequest(exception.requestOptions),
          );
          scope.setContexts('device_info', <String, dynamic>{
            'platform': defaultTargetPlatform.name,
          });
          scope.setContexts('app_info', <String, dynamic>{
            'base_url': exception.requestOptions.baseUrl,
          });

          _populateSentryContextSync(scope, exception);
          _detectAndTagTypeErrors(scope, exception);
        },
      );
    } catch (_) {
      // Logging must never break the repository flow.
    }
  }
}

class CleanDioException extends DioException {
  CleanDioException({
    required this.url,
    required this.method,
    required String message,
    required this.statusCode,
    required super.requestOptions,
    super.response,
    super.type = DioExceptionType.unknown,
    super.error,
  }) : super(message: message);

  final String url;
  final String method;
  final int? statusCode;
}

Map<String, dynamic> _authContextFromRequest(RequestOptions options) {
  try {
    final raw = options.headers['Authorization'];
    if (raw is String && raw.startsWith('Bearer ')) {
      final payload = _decodeJwt(raw.substring(7));
      if (payload != null) {
        return <String, dynamic>{
          'user_id': payload['id'] ?? payload['sub'],
          'email': payload['email'],
        };
      }
    }
  } catch (_) {
    // Ignore and fall through to the anonymous context.
  }
  return <String, dynamic>{'authenticated': false};
}

Map<String, dynamic>? _decodeJwt(String token) {
  try {
    final parts = token.split('.');
    if (parts.length != 3) return null;
    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    final payload = json.decode(decoded);
    if (payload is Map<String, dynamic>) return payload;
    return null;
  } catch (_) {
    return null;
  }
}

String _getCleanDioErrorMessage(DioException exception) {
  final data = exception.response?.data;
  if (data is Map<String, dynamic>) {
    for (final key in const ['message', 'error', 'msg']) {
      final value = data[key];
      if (value is String && value.isNotEmpty) return value;
      if (value is List && value.isNotEmpty) {
        return value.map((e) => e.toString()).join(', ');
      }
    }
  } else if (data is String && data.isNotEmpty) {
    return data;
  }

  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
      return 'Connection timed out. Please check your internet connection.';
    case DioExceptionType.connectionError:
      return 'No internet connection. Please check your internet connection.';
    case DioExceptionType.cancel:
      return 'Request was cancelled.';
    case DioExceptionType.badCertificate:
      return 'Unsecure connection. Please try again later.';
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      break;
  }

  final statusCode = exception.response?.statusCode;
  if (statusCode == 401) return 'Session expired. Please log in again.';
  if (statusCode != null) {
    return 'Request failed (HTTP $statusCode). Please try again.';
  }
  if (exception.message != null && exception.message!.isNotEmpty) {
    return exception.message!;
  }
  return 'Something went wrong. Please try again.';
}

void _populateSentryContextSync(Scope scope, DioException exception) {
  try {
    scope.setContexts('request_headers', <String, dynamic>{
      'content_type': exception.requestOptions.contentType,
      'has_authorization':
          exception.requestOptions.headers.containsKey('Authorization'),
    });
    final error = exception.error;
    if (error != null) {
      scope.setContexts('dio_error', <String, dynamic>{
        'runtime_type': '${error.runtimeType}',
        'message': '$error'.length > 1000 ? '$error'.substring(0, 1000) : '$error',
      });
    }
  } catch (_) {
    // Never throw from scope population.
  }
}

void _detectAndTagTypeErrors(Scope scope, DioException exception) {
  try {
    final error = exception.error;
    final message = '${exception.message} $error';
    final isTypeError =
        error is TypeError ||
        message.contains('is not a subtype of type') ||
        message.contains('_TypeError');
    if (isTypeError) {
      scope.setTag('error_kind', 'type_error');
      scope.setContexts('type_error', <String, dynamic>{
        'message': message.length > 2000 ? message.substring(0, 2000) : message,
      });
    }
  } catch (_) {
    // Never throw from scope tagging.
  }
}
