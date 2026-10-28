import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  String? email;
  String? password;
  @JsonKey(name: 'fcm_token')
  String? fcmToken;

  LoginRequest({this.email, this.password, this.fcmToken});

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
