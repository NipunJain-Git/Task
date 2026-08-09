import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaamsetu_app/features/auth/providers/auth_provider.dart';
import 'package:kaamsetu_app/features/profile/providers/profile_provider.dart';
import 'package:kaamsetu_app/features/profile/ui/worker_profile_screen.dart';
import 'package:kaamsetu_app/features/profile/ui/household_profile_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    final user = authState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login first')),
      );
    }

    if (user.role == 'WORKER') {
      return const WorkerProfileScreen();
    } else if (user.role == 'HOUSEHOLD') {
      return const HouseholdProfileScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Center(
        child: Text('Please complete your profile setup'),
      ),
    );
  }
}
