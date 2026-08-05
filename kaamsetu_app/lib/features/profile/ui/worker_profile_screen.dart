import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaamsetu_app/core/theme/app_theme.dart';
import 'package:kaamsetu_app/features/profile/providers/profile_provider.dart';
import 'package:kaamsetu_app/features/profile/models/worker_profile_model.dart';

class WorkerProfileScreen extends ConsumerStatefulWidget {
  const WorkerProfileScreen({super.key});

  @override
  ConsumerState<WorkerProfileScreen> createState() => _WorkerProfileScreenState();
}

class _WorkerProfileScreenState extends ConsumerState<WorkerProfileScreen> {
  final _nameController = TextEditingController();
  final _wageController = TextEditingController();
  final List<String> _selectedSkills = [];
  double _workRadius = 5.0;
  bool _isAvailable = true;

  final List<String> _availableSkills = [
    'Painting',
    'Plumbing',
    'Electrical',
    'Cleaning',
    'Carpentry',
    'Gardening',
    'Cooking',
    'Helper',
    'Driving',
    'Construction',
  ];

  @override
  void initState() {
    super.initState();
    ref.read(profileProvider.notifier).loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worker Profile'),
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

                  _buildSectionHeader('Skills'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableSkills.map((skill) {
                      final isSelected = _selectedSkills.contains(skill);
                      return FilterChip(
                        label: Text(skill),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _selectedSkills.add(skill);
                            } else {
                              _selectedSkills.remove(skill);
                            }
                          });
                        },
                        selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
                        checkmarkColor: AppTheme.primaryGreen,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Expected Wage'),
                  TextField(
                    controller: _wageController,
                    decoration: const InputDecoration(
                      labelText: 'Daily Wage (₹)',
                      prefixIcon: Icon(Icons.currency_rupee),
                      suffixText: 'per day',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Work Radius'),
                  Slider(
                    value: _workRadius,
                    min: 1,
                    max: 20,
                    divisions: 19,
                    label: '${_workRadius.round()} km',
                    onChanged: (value) {
                      setState(() {
                        _workRadius = value;
                      });
                    },
                  ),
                  Text(
                    'Willing to travel within ${_workRadius.round()} km',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 24),

                  _buildSectionHeader('Availability'),
                  SwitchListTile(
                    title: const Text('Available for work'),
                    subtitle: const Text('Turn off when you\'re not looking for work'),
                    value: _isAvailable,
                    onChanged: (value) {
                      setState(() {
                        _isAvailable = value;
                      });
                    },
                    activeColor: AppTheme.primaryGreen,
                  ),
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

    if (_selectedSkills.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one skill')),
      );
      return;
    }

    final wage = double.tryParse(_wageController.text);
    if (wage == null || wage <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid wage amount')),
      );
      return;
    }

    ref.read(profileProvider.notifier).updateWorkerProfile(
      name: _nameController.text,
      skills: _selectedSkills,
      expectedWage: wage,
      wageType: 'DAILY',
      isAvailable: _isAvailable,
      workRadius: _workRadius,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully')),
    );
  }
}
