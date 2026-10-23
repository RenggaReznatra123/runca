// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  emailVerifiedAt: json['email_verified_at'] as String?,
  deletedAt: json['deleted_at'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
  fcmToken: json['fcm_token'] as String?,
  phone: json['phone'] as String?,
  office: json['office'] == null
      ? null
      : OfficeModel.fromJson(json['office'] as Map<String, dynamic>),
  specialization: json['specialization'] == null
      ? null
      : SpecializationModel.fromJson(
          json['specialization'] as Map<String, dynamic>,
        ),
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'email_verified_at': instance.emailVerifiedAt,
  'deleted_at': instance.deletedAt,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
  'fcm_token': instance.fcmToken,
  'phone': instance.phone,
  'office': instance.office?.toJson(),
  'specialization': instance.specialization?.toJson(),
  'avatar': instance.avatar,
};

SpecializationModel _$SpecializationModelFromJson(Map<String, dynamic> json) =>
    SpecializationModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$SpecializationModelToJson(
  SpecializationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'created_at': instance.createdAt,
  'updated_at': instance.updatedAt,
};

OfficeModel _$OfficeModelFromJson(Map<String, dynamic> json) => OfficeModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  address: json['address'] as String?,
  latitude: json['latitude'] as String?,
  longitude: json['longitude'] as String?,
  radius: (json['radius'] as num?)?.toInt(),
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$OfficeModelToJson(OfficeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radius': instance.radius,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
