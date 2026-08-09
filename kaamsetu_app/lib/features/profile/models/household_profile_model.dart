import 'package:freezed_annotation/freezed_annotation.dart';

part 'household_profile_model.freezed.dart';
part 'household_profile_model.g.dart';

@freezed
abstract class HouseholdProfile with _$HouseholdProfile {
  const HouseholdProfile._();
  
  const factory HouseholdProfile({
    required String id,
    required String userId,
    String? address,
    @JsonKey(name: 'thumbsUp') @Default(0) int thumbsUp,
    @JsonKey(name: 'thumbsDown') @Default(0) int thumbsDown,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') required DateTime updatedAt,
  }) = _HouseholdProfile;

  factory HouseholdProfile.fromJson(Map<String, dynamic> json) =>
      _$HouseholdProfileFromJson(json);
  
  double get positiveRating {
    final total = thumbsUp + thumbsDown;
    if (total == 0) return 0.0;
    return (thumbsUp / total) * 100;
  }
}
