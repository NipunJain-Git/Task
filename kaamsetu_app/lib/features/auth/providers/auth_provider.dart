import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../models/user_model.dart';
import 'auth_state.dart';

final authNotifierProvider = NotifierProvider<AuthNotifier, AuthState>(() {
  return AuthNotifier();
});

class AuthNotifier extends Notifier<AuthState> {
  late Dio _dio;

  @override
  AuthState build() {
    _dio = ref.read(dioProvider);
    Future.microtask(() => checkAuthStatus());
    return const AuthState.initial();
  }

  Future<void> checkAuthStatus() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');
      if (token == null) {
        state = const AuthState.unauthenticated();
        return;
      }
      final response = await _dio.get('/users/profile');
      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data['data']);
        state = AuthState.authenticated(user);
      } else {
        await logout();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> sendOtp(String phone) async {
    try {
      state = const AuthState.loading();
      await _dio.post('/auth/send-otp', data: {'phone': phone});
      state = AuthState.otpSent(phone);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    try {
      state = const AuthState.loading();
      final response = await _dio.post('/auth/verify-otp', data: {
        'phone': phone,
        'otp': otp,
      });

      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken']);
      await prefs.setString('refreshToken', data['refreshToken']);
      
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
      state = AuthState.otpSent(phone);
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    state = const AuthState.unauthenticated();
  }
}
