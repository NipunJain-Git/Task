// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_interest_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_JobInterest _$JobInterestFromJson(Map<String, dynamic> json) => _JobInterest(
  id: json['id'] as String,
  jobId: json['jobId'] as String,
  workerId: json['workerId'] as String,
  worker: UserModel.fromJson(json['worker'] as Map<String, dynamic>),
  status: json['status'] as String? ?? 'PENDING',
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$JobInterestToJson(_JobInterest instance) =>
    <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'workerId': instance.workerId,
      'worker': instance.worker,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
