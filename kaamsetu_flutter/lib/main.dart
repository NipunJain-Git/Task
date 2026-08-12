import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'core/theme.dart';
import 'providers/app_provider.dart';
import 'screens/shared/landing_screen.dart';
import 'screens/shared/home_shell.dart';
import 'screens/shared/home_shell.dart' show KaamSetuLogo;
import 'screens/auth/login_screen.dart';
import 'screens/auth/onboarding_screen.dart';
import 'screens/shared/chat_screen.dart';
import 'screens/admin/admin_dashboard.dart';

Future<void> main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    // Request notification permissions
    final messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Just print for now — could show a snackbar in the future
      print('FCM foreground message: ${message.notification?.title}');
    });
    runApp(
      ChangeNotifierProvider(
        create: (_) => AppProvider(),
        child: const KaamSetuApp(),
      ),
    );
  } catch (e, stackTrace) {
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Text(
              "FATAL STARTUP ERROR:\n\n$e\n\n$stackTrace",
              style: const TextStyle(color: Colors.redAccent, fontSize: 14),
            ),
          ),
        ),
      ),
    ));
  }
}

class KaamSetuApp extends StatelessWidget {
  const KaamSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, provider, _) {
        return MaterialApp(
          title: 'KaamSetu',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          initialRoute: '/splash',
          onGenerateRoute: (settings) {
            switch (settings.name) {
              case '/splash':
                return MaterialPageRoute(builder: (_) => const SplashScreen());
              case '/landing':
                return MaterialPageRoute(builder: (_) => const LandingScreen());
              case '/login':
                final args = settings.arguments as Map<String, dynamic>?;
                return MaterialPageRoute(
                  builder: (_) => LoginScreen(initialRole: args?['role'] as String?),
                );
              case '/onboarding':
                final args = settings.arguments as Map<String, dynamic>;
                return MaterialPageRoute(
                  builder: (_) => OnboardingScreen(
                    role: args['role'] as String,
                    lang: args['lang'] as String? ?? 'en',
                    phone: args['phone'] as String? ?? '',
                  ),
                );
              case '/chat':
                final args = settings.arguments as Map<String, String>;
                return MaterialPageRoute(
                  builder: (_) => ChatScreen(
                    jobId: args['jobId']!,
                    otherUserId: args['otherUserId']!,
                    otherUserName: args['otherUserName']!,
                    jobTitle: args['jobTitle']!,
                  ),
                );
              case '/home':
                return MaterialPageRoute(builder: (_) => const HomeShell());
              case '/admin':
                return MaterialPageRoute(builder: (_) => AdminDashboard());
              default:
                return MaterialPageRoute(builder: (_) => const LandingScreen());
            }
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 1600), () {
      if (!mounted) return;
      final provider = context.read<AppProvider>();
      if (provider.isAuthenticated) {
        if (provider.user?.role == 'ADMIN') {
          Navigator.of(context).pushReplacementNamed('/admin');
        } else {
          Navigator.of(context).pushReplacementNamed('/home');
        }
      } else {
        Navigator.of(context).pushReplacementNamed('/landing');
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: ScaleTransition(
            scale: _scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 96, height: 96,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 32, offset: const Offset(0, 8))],
                  ),
                  child: Center(
                    child: Text('K',
                        style: TextStyle(fontSize: 52, fontWeight: FontWeight.w900, color: AppTheme.primary, height: 1)),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('KaamSetu',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: -0.5)),
                const SizedBox(height: 8),
                Text('Work near you, today',
                    style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.8), fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
