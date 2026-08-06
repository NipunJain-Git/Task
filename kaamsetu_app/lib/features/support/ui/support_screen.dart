import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kaamsetu_app/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.customerCare)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.primaryGreen,
              child: Icon(Icons.support_agent, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'Parth - Head of Customer Support',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text('We are here to help you 24/7.'),
            const SizedBox(height: 32),
            
            _ContactTile(
              icon: Icons.phone,
              title: 'Direct Phone',
              subtitle: '+91 84339 27633',
              onTap: () {},
            ),
            _ContactTile(
              icon: Icons.headset_mic,
              title: 'Toll-Free Helpline',
              subtitle: '1800-890-PARTH',
              onTap: () {},
            ),
            _ContactTile(
              icon: Icons.email,
              title: 'Support Email',
              subtitle: 'parth.care@kaamsetu.in',
              onTap: () {},
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton.icon(
              icon: const Icon(Icons.chat),
              label: Text(l10n.aiChatbot),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => context.push('/support/chatbot'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.sos),
              label: const Text('SOS Call to Family Member'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactTile({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        leading: Icon(icon, color: AppTheme.primaryGreen),
        title: Text(title),
        subtitle: Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        onTap: onTap,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
