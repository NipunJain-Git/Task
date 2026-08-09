import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firebase_options.dart';

final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

class FirebaseService {
  static const String _fcmTokenKey = 'fcm_token';
  
  Future<void> initialize() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } on FirebaseException catch (e) {
      if (e.code != 'duplicate-app') {
        rethrow;
      }
    } catch (e) {
      if (!e.toString().contains('duplicate-app')) {
        rethrow;
      }
    }
    
    if (!kIsWeb) {
      try {
        await _setupMessaging();
      } catch (e) {
        if (kDebugMode) {
          print('Failed to setup Firebase Messaging: $e');
        }
        // Continue app initialization even if FCM fails (e.g., FIS_AUTH_ERROR due to missing SHA-1)
      }
    }
  }

  
  Future<void> _setupMessaging() async {
    final messaging = FirebaseMessaging.instance;
    
    // Request permission
    final settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    
    if (kDebugMode) {
      print('Firebase messaging permission granted: ${settings.authorizationStatus}');
    }
    
    // Get FCM token
    final token = await messaging.getToken();
    if (token != null) {
      await _saveFcmToken(token);
      if (kDebugMode) {
        print('FCM Token: $token');
      }
    }
    
    // Listen to token refresh
    messaging.onTokenRefresh.listen((newToken) {
      _saveFcmToken(newToken);
      if (kDebugMode) {
        print('FCM Token refreshed: $newToken');
      }
    });
    
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      if (kDebugMode) {
        print('Received foreground message: ${message.notification?.title}');
      }
    });
    
    // Handle background messages
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      if (kDebugMode) {
        print('Message opened from background: ${message.notification?.title}');
      }
    });
  }
  
  Future<void> _saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenKey, token);
  }
  
  Future<String?> getFcmToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenKey);
  }
}
