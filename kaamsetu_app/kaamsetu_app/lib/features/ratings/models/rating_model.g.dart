// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Rating _$RatingFromJson(Map<String, dynamic> json) => _Rating(
  id: json['id'] as String,
  jobId: json['jobId'] as String,
  raterId: json['raterId'] as String,
  ratedUserId: json['ratedUserId'] as String,
  value: json['value'] as String,
  comment: json['comment'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$RatingToJson(_Rating instance) => <String, dynamic>{
  'id': instance.id,
  'jobId': instance.jobId,
  'raterId': instance.raterId,
  'ratedUserId': instance.ratedUserId,
  'value': instance.value,
  'comment': instance.comment,
  'createdAt': instance.createdAt.toIso8601String(),
};
