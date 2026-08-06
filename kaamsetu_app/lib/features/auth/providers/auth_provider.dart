import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _verificationId;

  @override
  AuthState build() {
    _dio = ref.read(dioProvider);
    Future.microtask(() => checkAuthStatus());
    return const AuthState.initial();
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    
    if (token != null) {
      try {
        final response = await _dio.get('/users/me');
        final data = response.data['data'] as Map<String, dynamic>;
        final user = UserModel.fromJson(data);
        state = AuthState.authenticated(user);
      } catch (e) {
        state = const AuthState.unauthenticated();
      }
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> sendOtp(String phone) async {
    try {
      state = const AuthState.loading();
      final formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
      
      await _dio.post('/auth/send-otp', data: {'phone': formattedPhone});
      state = AuthState.otpSent(formattedPhone);
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

      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken'] as String);
      await prefs.setString('refreshToken', data['refreshToken'] as String);
      
      if (data['user']['isNewUser'] == true) {
        state = AuthState.roleSelection(phone);
      } else {
        state = AuthState.authenticated(user);
      }
    } catch (e) {
      state = AuthState.error(e.toString());
      state = AuthState.otpSent(phone);
    }
  }

  Future<void> selectRole(String role, {String? familyMemberContact, String? familyMemberRelation}) async {
    try {
      state = const AuthState.loading();
      final response = await _dio.post('/auth/select-role', data: {
        'role': role,
        if (familyMemberContact != null) 'familyMemberContact': familyMemberContact,
        if (familyMemberRelation != null) 'familyMemberRelation': familyMemberRelation,
      });

      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken'] as String);
      
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken');
    await prefs.remove('refreshToken');
    state = const AuthState.unauthenticated();
  }
}
