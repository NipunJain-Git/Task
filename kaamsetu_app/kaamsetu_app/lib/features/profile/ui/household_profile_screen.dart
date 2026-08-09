import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaamsetu_app/core/theme/app_theme.dart';
import 'package:kaamsetu_app/features/profile/providers/profile_provider.dart';

class HouseholdProfileScreen extends ConsumerStatefulWidget {
  const HouseholdProfileScreen({super.key});

  @override
  ConsumerState<HouseholdProfileScreen> createState() => _HouseholdProfileScreenState();
}

class _HouseholdProfileScreenState extends ConsumerState<HouseholdProfileScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(profileProvider.notifier).loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Household Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveProfile,
          ),
        ],
      ),
      body: profileState.status == ProfileStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('Basic Information'),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Address'),
                  TextField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Home Address',
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  if (profileState.householdProfile != null) ...[
                    _buildSectionHeader('Your Rating'),
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Icon(
                              Icons.thumb_up,
                              color: AppTheme.primaryGreen,
                              size: 32,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${profileState.householdProfile!.positiveRating.toStringAsFixed(0)}% Positive',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${profileState.householdProfile!.thumbsUp} 👍 / ${profileState.householdProfile!.thumbsDown} 👎)',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          color: AppTheme.primaryGreen,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your name')),
      );
      return;
    }

    ref.read(profileProvider.notifier).updateHouseholdProfile(
      name: _nameController.text,
      address: _addressController.text.isNotEmpty ? _addressController.text : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully')),
    );
  }
}
