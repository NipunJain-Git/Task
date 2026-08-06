import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../jobs/providers/jobs_provider.dart';
import '../ui/dashboard_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final profileState = ref.watch(profileProvider);
    final jobsState = ref.watch(jobsProvider);

    final user = authState.maybeWhen(
      authenticated: (u) => u,
      orElse: () => null,
    );

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please login first')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('KaamSetu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeSection(context, user),
            const SizedBox(height: 24),
            if (user.role == 'WORKER') ...[
              _buildWorkerDashboard(context, ref, profileState, jobsState),
            ] else if (user.role == 'HOUSEHOLD') ...[
              _buildHouseholdDashboard(context, ref, profileState, jobsState),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, dynamic user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, ${user.name ?? "User"}!',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Role: ${user.role ?? "Guest"}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkerDashboard(BuildContext context, WidgetRef ref, dynamic profileState, dynamic jobsState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Worker Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        DashboardCard(
          icon: Icons.work,
          title: 'Available Jobs',
          subtitle: '${jobsState.jobs.length} jobs nearby',
          onTap: () {
            context.go('/jobs');
          },
        ),
        const SizedBox(height: 12),
        DashboardCard(
          icon: Icons.person,
          title: 'My Profile',
          subtitle: 'Complete your profile',
          onTap: () {
            context.go('/profile');
          },
        ),
        const SizedBox(height: 12),
        if (profileState.workerProfile != null)
          DashboardCard(
            icon: profileState.workerProfile!.isAvailable == true
                ? Icons.toggle_on
                : Icons.toggle_off,
            title: 'Availability',
            subtitle: profileState.workerProfile!.isAvailable == true
                ? 'Available for work'
                : 'Not available',
            onTap: () {
              ref.read(profileProvider.notifier).toggleAvailability(
                profileState.workerProfile!.isAvailable == false,
              );
            },
          ),
      ],
    );
  }

  Widget _buildHouseholdDashboard(BuildContext context, WidgetRef ref, dynamic profileState, dynamic jobsState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Household Dashboard',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        DashboardCard(
          icon: Icons.post_add,
          title: 'Post a Job',
          subtitle: 'Create a new job posting',
          onTap: () {
            context.go('/jobs');
          },
        ),
        const SizedBox(height: 12),
        DashboardCard(
          icon: Icons.list,
          title: 'My Posted Jobs',
          subtitle: '${jobsState.jobs.length} active jobs',
          onTap: () {
            ref.read(jobsProvider.notifier).loadMyJobs();
            context.go('/jobs');
          },
        ),
        const SizedBox(height: 12),
        DashboardCard(
          icon: Icons.person,
          title: 'My Profile',
          subtitle: 'Manage your profile',
          onTap: () {
            context.go('/profile');
          },
        ),
      ],
    );
  }
}
