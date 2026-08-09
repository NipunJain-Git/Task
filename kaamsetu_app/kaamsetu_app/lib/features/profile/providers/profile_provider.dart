import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaamsetu_app/core/network/api_client.dart';
import 'package:kaamsetu_app/features/auth/models/user_model.dart';
import 'package:kaamsetu_app/features/profile/models/worker_profile_model.dart';
import 'package:kaamsetu_app/features/profile/models/household_profile_model.dart';

enum ProfileStatus { initial, loading, loaded, error }


class ProfileState {
  final ProfileStatus status;
  final UserModel? user;
  final WorkerProfile? workerProfile;
  final HouseholdProfile? householdProfile;
  final String? errorMessage;

  const ProfileState({
    this.status = ProfileStatus.initial,
    this.user,
    this.workerProfile,
    this.householdProfile,
    this.errorMessage,
  });

  ProfileState copyWith({
    ProfileStatus? status,
    UserModel? user,
    WorkerProfile? workerProfile,
    HouseholdProfile? householdProfile,
    String? errorMessage,
  }) {
    return ProfileState(
      status: status ?? this.status,
      user: user ?? this.user,
      workerProfile: workerProfile ?? this.workerProfile,
      householdProfile: householdProfile ?? this.householdProfile,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileNotifier extends Notifier<ProfileState> {
  late Dio _dio;

  @override
  ProfileState build() {
    _dio = ref.watch(dioProvider);
    return const ProfileState();
  }

  Future<void> loadProfile() async {
    try {
      state = state.copyWith(status: ProfileStatus.loading);
      final response = await _dio.get('/users/me');
      
      final userData = response.data['data'];
      final user = UserModel.fromJson(userData as Map<String, dynamic>);
      
      if (user.role == 'WORKER' && userData['workerProfile'] != null) {
        final workerProfile = WorkerProfile.fromJson(userData['workerProfile'] as Map<String, dynamic>);
        state = state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          workerProfile: workerProfile,
        );
      } else if (user.role == 'HOUSEHOLD' && userData['householdProfile'] != null) {
        final householdProfile = HouseholdProfile.fromJson(userData['householdProfile'] as Map<String, dynamic>);
        state = state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
          householdProfile: householdProfile,
        );
      } else {
        state = state.copyWith(
          status: ProfileStatus.loaded,
          user: user,
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateWorkerProfile({
    required String name,
    required List<String> skills,
    double? expectedWage,
    String wageType = 'DAILY',
    bool isAvailable = true,
    double workRadius = 5.0,
  }) async {
    try {
      state = state.copyWith(status: ProfileStatus.loading);
      await _dio.put('/users/me/worker-profile', data: {
        'name': name,
        'skills': skills,
        'expectedWage': expectedWage,
        'wageType': wageType,
        'isAvailable': isAvailable,
        'workRadius': workRadius,
      });
      await loadProfile();
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateHouseholdProfile({
    required String name,
    String? address,
  }) async {
    try {
      state = state.copyWith(status: ProfileStatus.loading);
      await _dio.put('/users/me/household-profile', data: {
        'name': name,
        'address': address,
      });
      await loadProfile();
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> toggleAvailability(bool isAvailable) async {
    try {
      await _dio.patch('/users/me/availability', data: {
        'isAvailable': isAvailable,
      });
      if (state.workerProfile != null) {
        state = state.copyWith(
          workerProfile: state.workerProfile!.copyWith(isAvailable: isAvailable),
        );
      }
    } catch (e) {
      state = state.copyWith(
        status: ProfileStatus.error,
        errorMessage: e.toString(),
      );
    }
  }
}

final profileProvider = NotifierProvider<ProfileNotifier, ProfileState>(() {
  return ProfileNotifier();
});
