// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'household_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HouseholdProfile _$HouseholdProfileFromJson(Map<String, dynamic> json) =>
    _HouseholdProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      address: json['address'] as String?,
      thumbsUp: (json['thumbsUp'] as num?)?.toInt() ?? 0,
      thumbsDown: (json['thumbsDown'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$HouseholdProfileToJson(_HouseholdProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'address': instance.address,
      'thumbsUp': instance.thumbsUp,
      'thumbsDown': instance.thumbsDown,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
