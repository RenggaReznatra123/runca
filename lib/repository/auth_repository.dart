import 'package:runca/models/request/login_request.dart';
import 'package:runca/models/response/api_response.dart';
import 'package:runca/models/response/auth_response.dart';

import '../data/api_service.dart';
import '../utility/resource/data_state.dart';
import 'base_repository.dart';

class AuthRepository extends BaseRepository {
  AuthRepository(this._apiService);

  final ApiService _apiService;

  Future<DataState<AuthResponse>> login(LoginRequest body) async {
    final DataState<AuthResponse> dataState = await getStateOf(
      request: () => _apiService.login(request: body),
    );
    if (dataState is DataStateSuccess) {
      return DataStateSuccess(dataState.data!);
    } else {
      return DataStateError(dataState.exception!);
    }
  }

  Future<DataState<ApiResponse>> updateFcmToken(String fcmToken) async {
    final DataState<ApiResponse> dataState = await getStateOf(
      request: () =>
          _apiService.updateFcmToken(request: {'fcm_token': fcmToken}),
    );
    if (dataState is DataStateSuccess) {
      return DataStateSuccess(dataState.data!);
    } else {
      return DataStateError(dataState.exception!);
    }
  }

  Future<DataState<ApiResponse>> logout() async {
    final DataState<ApiResponse> dataState = await getStateOf(
      request: () => _apiService.logout(),
    );
    if (dataState is DataStateSuccess) {
      return DataStateSuccess(dataState.data!);
    } else {
      return DataStateError(dataState.exception!);
    }
  }
}
