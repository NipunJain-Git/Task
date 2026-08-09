import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/providers/auth_provider.dart';
import 'job_feed_screen.dart';
import 'post_job_screen.dart';

class JobsScreen extends ConsumerWidget {
  const JobsScreen({super.key});

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
      return const JobFeedScreen();
    } else if (user.role == 'HOUSEHOLD') {
      return const PostJobScreen();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Jobs')),
      body: const Center(
        child: Text('Please complete your profile setup'),
      ),
    );
  }
}
