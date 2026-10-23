import 'package:dio/dio.dart';

/// Human-readable message extraction for [DioException].
extension DioExceptionExtension on Exception {
  String parseMessage() {
    final self = this;
    if (self is! DioException) return self.toString();

    switch (self.type) {
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
      case DioExceptionType.unknown:
      case DioExceptionType.badResponse:
        break;
    }

    final statusCode = self.response?.statusCode;
    if (statusCode == 401) {
      return 'Session expired. Please log in again.';
    }

    // Try to extract server-provided message.
    final data = self.response?.data;
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

    if (statusCode != null) {
      return 'Request failed (HTTP $statusCode). Please try again.';
    }
    return self.message ?? 'Something went wrong. Please try again.';
  }
}
