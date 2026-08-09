import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaamsetu_app/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  final _contactController = TextEditingController();
  String _selectedRelation = 'Father';
  final _relations = ['Father', 'Mother', 'Spouse', 'Brother', 'Relative'];

  @override
  void dispose() {
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 48),
              Text(
                l10n.roleSelectionTitle,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.primaryGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.roleSelectionSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Family Contact Fields
              Text(
                l10n.familyContactNo,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'e.g. 9876543210',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.familyRelation,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedRelation,
                items: _relations.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedRelation = val);
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              _RoleCard(
                icon: Icons.work,
                title: l10n.workerRole,
                description: l10n.workerRoleDescription,
                onTap: () => _selectRole('WORKER'),
              ),
              const SizedBox(height: 16),
              
              _RoleCard(
                icon: Icons.home,
                title: l10n.householdRole,
                description: l10n.householdRoleDescription,
                onTap: () => _selectRole('HOUSEHOLD'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectRole(String role) {
    final contact = _contactController.text.trim();
    if (contact.isEmpty || contact.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid family contact number')),
      );
      return;
    }
    
    ref.read(authNotifierProvider.notifier).selectRole(
      role, 
      familyMemberContact: contact,
      familyMemberRelation: _selectedRelation
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 32,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios),
            ],
          ),
        ),
      ),
    );
  }
}
