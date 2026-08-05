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
      
      // Formatting phone for Firebase (assuming India +91)
      final formattedPhone = phone.startsWith('+') ? phone : '+91$phone';

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution on Android
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          state = AuthState.error(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          state = AuthState.otpSent(phone);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> verifyOtp(String phone, String otp) async {
    try {
      state = const AuthState.loading();
      if (_verificationId == null) {
        throw Exception('Verification ID is null. Request OTP again.');
      }
      
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      
      await _signInWithCredential(credential);
    } catch (e) {
      state = AuthState.error(e.toString());
      state = AuthState.otpSent(phone); // fallback if it fails
    }
  }
  
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      final firebaseUser = userCredential.user;
      
      if (firebaseUser == null) {
        throw Exception('Failed to sign in with Firebase.');
      }
      
      final idToken = await firebaseUser.getIdToken();
      
      // Send Firebase token to our Node.js backend
      final response = await _dio.post('/auth/verify-firebase', data: {
        'idToken': idToken,
      });

      final data = response.data['data'] as Map<String, dynamic>;
      final user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('accessToken', data['accessToken'] as String);
      await prefs.setString('refreshToken', data['refreshToken'] as String);
      
      if (data['user']['isNewUser'] == true) {
        state = AuthState.roleSelection(firebaseUser.phoneNumber ?? '');
      } else {
        state = AuthState.authenticated(user);
      }
    } catch (e) {
      state = AuthState.error(e.toString());
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
