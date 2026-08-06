import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/providers/auth_state.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/auth/ui/role_selection_screen.dart';
import '../../features/home/ui/home_screen.dart';
import '../../features/jobs/ui/jobs_screen.dart';
import '../../features/jobs/ui/job_detail_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/wallet/ui/wallet_dashboard_screen.dart';
import '../../features/wallet/ui/setup_pin_screen.dart';
import '../../features/support/ui/support_screen.dart';
import '../../features/support/ui/chatbot_screen.dart';
import '../../features/kyc/presentation/screens/kyc_screen.dart';
import '../../features/admin/presentation/screens/admin_dashboard.dart';
import 'main_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = authState.maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
      
      final needsRoleSelection = authState.maybeWhen(
        roleSelection: (_) => true,
        orElse: () => false,
      );
      
      final isLoggingIn = state.uri.path == '/login';
      final isRoleSelectionRoute = state.uri.path == '/role-selection';
      final isAdminRoute = state.uri.path == '/admin';
      
      if (needsRoleSelection && !isRoleSelectionRoute && !isAdminRoute) return '/role-selection';
      if (!isAuth && !isLoggingIn && !isRoleSelectionRoute && !isAdminRoute) return '/login';
      if (isAuth && isLoggingIn) return '/home';
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/role-selection',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/jobs',
            builder: (context, state) => const JobsScreen(),
          ),
          GoRoute(
            path: '/jobs/:jobId',
            builder: (context, state) {
              final jobId = state.pathParameters['jobId']!;
              return JobDetailScreen(jobId: jobId);
            },
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/wallet',
            builder: (context, state) => const WalletDashboardScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/setup-pin',
        builder: (context, state) => const SetupPinScreen(),
      ),
      GoRoute(
        path: '/kyc',
        builder: (context, state) => const KycScreen(),
      ),
      GoRoute(
        path: '/support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/support/chatbot',
        builder: (context, state) => const ChatbotScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
    ],
  );
});
