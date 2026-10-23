import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable(explicitToJson: true)
class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.fcmToken,
    this.phone,
    this.office,
    this.specialization,
    this.avatar,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'email')
  final String? email;

  @JsonKey(name: 'email_verified_at')
  final String? emailVerifiedAt;

  @JsonKey(name: 'deleted_at')
  final String? deletedAt;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  @JsonKey(name: 'fcm_token')
  final String? fcmToken;

  @JsonKey(name: 'phone')
  final String? phone;

  @JsonKey(name: 'office')
  final OfficeModel? office;

  @JsonKey(name: 'specialization')
  final SpecializationModel? specialization;

  @JsonKey(name: 'avatar')
  final String? avatar;

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

@JsonSerializable()
class SpecializationModel {
  SpecializationModel({this.id, this.name, this.createdAt, this.updatedAt});

  factory SpecializationModel.fromJson(Map<String, dynamic> json) =>
      _$SpecializationModelFromJson(json);

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, dynamic> toJson() => _$SpecializationModelToJson(this);
}

@JsonSerializable()
class OfficeModel {
  OfficeModel({
    this.id,
    this.name,
    this.address,
    this.latitude,
    this.longitude,
    this.radius,
    this.createdAt,
    this.updatedAt,
  });

  factory OfficeModel.fromJson(Map<String, dynamic> json) =>
      _$OfficeModelFromJson(json);

  @JsonKey(name: 'id')
  final int? id;

  @JsonKey(name: 'name')
  final String? name;

  @JsonKey(name: 'address')
  final String? address;

  @JsonKey(name: 'latitude')
  final String? latitude;

  @JsonKey(name: 'longitude')
  final String? longitude;

  @JsonKey(name: 'radius')
  final int? radius;

  @JsonKey(name: 'created_at')
  final String? createdAt;

  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Map<String, dynamic> toJson() => _$OfficeModelToJson(this);
}
