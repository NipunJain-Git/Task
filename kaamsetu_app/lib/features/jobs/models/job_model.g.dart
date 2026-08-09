// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Job _$JobFromJson(Map<String, dynamic> json) => _Job(
  id: json['id'] as String,
  householdId: json['householdId'] as String,
  household: UserModel.fromJson(json['household'] as Map<String, dynamic>),
  title: json['title'] as String,
  description: json['description'] as String,
  category: json['category'] as String,
  jobDate: DateTime.parse(json['jobDate'] as String),
  jobTime: json['jobTime'] as String?,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  address: json['address'] as String?,
  budgetAmount: (json['budgetAmount'] as num).toDouble(),
  budgetType: json['budgetType'] as String? ?? 'FIXED',
  status: json['status'] as String? ?? 'OPEN',
  assignedWorkerId: json['assignedWorkerId'] as String?,
  assignedWorker: json['assignedWorker'] == null
      ? null
      : UserModel.fromJson(json['assignedWorker'] as Map<String, dynamic>),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$JobToJson(_Job instance) => <String, dynamic>{
  'id': instance.id,
  'householdId': instance.householdId,
  'household': instance.household,
  'title': instance.title,
  'description': instance.description,
  'category': instance.category,
  'jobDate': instance.jobDate.toIso8601String(),
  'jobTime': instance.jobTime,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'address': instance.address,
  'budgetAmount': instance.budgetAmount,
  'budgetType': instance.budgetType,
  'status': instance.status,
  'assignedWorkerId': instance.assignedWorkerId,
  'assignedWorker': instance.assignedWorker,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};
