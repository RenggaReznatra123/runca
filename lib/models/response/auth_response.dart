import 'package:runca/models/user_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'auth_response.g.dart';

@JsonSerializable()
class AuthResponse {
  bool? success;
  int? code;
  AuthResponseData? data;

  AuthResponse({this.success, this.code, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class AuthResponseData {
  UserModel? user;
  @JsonKey(name: 'access_token')
  String? accessToken;
  @JsonKey(name: 'token_type')
  String? tokenType;

  AuthResponseData({this.user, this.accessToken, this.tokenType});

  factory AuthResponseData.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseDataToJson(this);
}
