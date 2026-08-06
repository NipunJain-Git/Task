// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'worker_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorkerProfile _$WorkerProfileFromJson(Map<String, dynamic> json) =>
    _WorkerProfile(
      id: json['id'] as String,
      userId: json['userId'] as String,
      skills: (json['skills'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      expectedWage: (json['expectedWage'] as num?)?.toDouble(),
      wageType: json['wageType'] as String? ?? 'DAILY',
      isAvailable: json['isAvailable'] as bool? ?? true,
      workRadius: (json['workRadius'] as num?)?.toDouble() ?? 5.0,
      thumbsUp: (json['thumbsUp'] as num?)?.toInt() ?? 0,
      thumbsDown: (json['thumbsDown'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$WorkerProfileToJson(_WorkerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'skills': instance.skills,
      'expectedWage': instance.expectedWage,
      'wageType': instance.wageType,
      'isAvailable': instance.isAvailable,
      'workRadius': instance.workRadius,
      'thumbsUp': instance.thumbsUp,
      'thumbsDown': instance.thumbsDown,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
