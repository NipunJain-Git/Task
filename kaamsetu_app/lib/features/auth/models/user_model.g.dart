// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: json['id'] as String,
  phone: json['phone'] as String,
  role: json['role'] as String?,
  name: json['name'] as String?,
  photoUrl: json['photoUrl'] as String?,
  language: json['language'] as String? ?? 'en',
  isNewUser: json['isNewUser'] as bool?,
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'phone': instance.phone,
  'role': instance.role,
  'name': instance.name,
  'photoUrl': instance.photoUrl,
  'language': instance.language,
  'isNewUser': instance.isNewUser,
};
