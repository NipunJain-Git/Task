// ignore_for_file: type=lint
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String phone;
  final String? role;
  final String? name;
  final String? photoUrl;
  @JsonKey(defaultValue: 'en')
  final String language;
  final bool? isNewUser;

  const UserModel({
    required this.id,
    required this.phone,
    this.role,
    this.name,
    this.photoUrl,
    this.language = 'en',
    this.isNewUser,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserModel copyWith({
    String? id,
    String? phone,
    String? role,
    String? name,
    String? photoUrl,
    String? language,
    bool? isNewUser,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      language: language ?? this.language,
      isNewUser: isNewUser ?? this.isNewUser,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          phone == other.phone;

  @override
  int get hashCode => id.hashCode ^ phone.hashCode;

  @override
  String toString() =>
      'UserModel(id: $id, phone: $phone, role: $role, name: $name)';
}
