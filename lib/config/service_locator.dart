import 'package:awesome_dio_interceptor/awesome_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api_service.dart';
import 'constants.dart';
import 'user_preference.dart';
import 'repository_locator.dart';

final GetIt serviceLocator = GetIt.instance;

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> setUpLocator() async {
  if (serviceLocator.isRegistered<UserPreference>()) return;

  final prefs = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<UserPreference>(UserPreference(prefs));
  registerRepositories(serviceLocator);

  serviceLocator.registerFactory<Dio>(() {
    final userPreference = serviceLocator.get<UserPreference>();
    final token = userPreference.getToken();

    final dio = Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: <String, dynamic>{
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'x-api-key': apiKey,
          if (token != null && token.isNotEmpty)
            'Authorization': 'Bearer $token',
        },
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(AwesomeDioInterceptorWrapper());
    }
    dio.interceptors.add(UnauthorizedInterceptor());

    return dio;
  });

  serviceLocator.registerFactory<ApiService>(
    () => ApiService(serviceLocator.get<Dio>(), baseUrl: baseApi),
  );

  final packageInfo = await PackageInfo.fromPlatform();
  serviceLocator.registerSingleton<PackageInfo>(packageInfo);
}

class AwesomeDioInterceptorWrapper extends Interceptor {
  final AwesomeDioInterceptor _inner = AwesomeDioInterceptor();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      _inner.onRequest(options, handler);
    } catch (_) {
      handler.next(options);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    try {
      _inner.onResponse(response, handler);
    } catch (_) {
      handler.next(response);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      _inner.onError(err, handler);
    } catch (_) {
      handler.next(err);
    }
  }
}

class UnauthorizedInterceptor extends Interceptor {
  bool _isRedirectingToLogin = false;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !_isRedirectingToLogin) {
      _isRedirectingToLogin = true;
      try {
        await serviceLocator.get<UserPreference>().clearSession();
        // navigatorKey.currentState?.pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (_) => const LoginScreen()),
        //   (_) => false,
        // );
      } finally {
        await Future.delayed(const Duration(seconds: 1));
        _isRedirectingToLogin = false;
      }
    }
    handler.next(err);
  }
}
