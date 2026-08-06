import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaamsetu_app/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        error: (message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        },
        orElse: () {},
      );
    });

    final authState = ref.watch(authNotifierProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.loginTitle,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppTheme.primaryGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.loginSubtitle,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 48),
              
              authState.maybeWhen(
                otpSent: (phone) => Column(
                  children: [
                    TextField(
                      controller: _otpController,
                      decoration: const InputDecoration(
                        labelText: 'OTP (Mock: 123456)',
                        prefixIcon: Icon(Icons.security),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(authNotifierProvider.notifier).verifyOtp(
                          phone,
                          _otpController.text,
                        );
                      },
                      child: Text(l10n.verifyOtp),
                    ),
                  ],
                ),
                roleSelection: (phone) => Column(
                  children: [
                    const Icon(Icons.check_circle, size: 64, color: Colors.green),
                    const SizedBox(height: 16),
                    const Text('OTP Verified!'),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        context.go('/role-selection');
                      },
                      child: const Text('Continue'),
                    ),
                  ],
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                orElse: () => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _phoneController,
                      decoration: InputDecoration(
                        labelText: l10n.phoneLabel,
                        prefixIcon: const Icon(Icons.phone),
                        prefixText: '+91 ',
                      ),
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        if (_phoneController.text.length == 10) {
                          ref.read(authNotifierProvider.notifier).sendOtp(_phoneController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Enter valid 10-digit phone number')),
                          );
                        }
                      },
                      child: Text(l10n.sendOtp),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
