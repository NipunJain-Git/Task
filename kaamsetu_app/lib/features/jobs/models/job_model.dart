import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kaamsetu_app/features/auth/models/user_model.dart';

part 'job_model.freezed.dart';
part 'job_model.g.dart';

@freezed
abstract class Job with _$Job {
  const factory Job({
    required String id,
    @JsonKey(name: 'householdId') required String householdId,
    @JsonKey(name: 'household') required UserModel household,
    required String title,
    required String description,
    required String category,
    @JsonKey(name: 'jobDate') required DateTime jobDate,
    String? jobTime,
    required double latitude,
    required double longitude,
    String? address,
    @JsonKey(name: 'budgetAmount') required double budgetAmount,
    @JsonKey(name: 'budgetType') @Default('FIXED') String budgetType,
    @JsonKey(name: 'status') @Default('OPEN') String status,
    @JsonKey(name: 'assignedWorkerId') String? assignedWorkerId,
    @JsonKey(name: 'assignedWorker') UserModel? assignedWorker,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _Job;

  factory Job.fromJson(Map<String, dynamic> json) => _$JobFromJson(json);
}

@freezed
abstract class JobFilter with _$JobFilter {
  const factory JobFilter({
    double? latitude,
    double? longitude,
    @Default(5.0) double radius,
    String? category,
    DateTime? date,
    @Default('OPEN') String status,
    @Default(1) int page,
    @Default(20) int limit,
  }) = _JobFilter;
}
