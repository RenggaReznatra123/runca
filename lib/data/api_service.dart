import 'package:runca/models/request/login_request.dart';
import 'package:runca/models/response/api_response.dart';
import 'package:runca/models/response/auth_response.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../config/constants.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: baseApi, parser: Parser.JsonSerializable)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  /// Auth

  @POST("/login")
  Future<HttpResponse<AuthResponse>> login({
    @Body() required LoginRequest request,
  });

  @POST("/update-fcm-token")
  Future<HttpResponse<ApiResponse>> updateFcmToken({
    @Body() required Map<String, dynamic> request,
  });

  @POST("/logout")
  Future<HttpResponse<ApiResponse>> logout();
}
