import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaamsetu_app/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/wallet_provider.dart';
import '../providers/wallet_state.dart';

class SetupPinScreen extends ConsumerStatefulWidget {
  const SetupPinScreen({super.key});

  @override
  ConsumerState<SetupPinScreen> createState() => _SetupPinScreenState();
}

class _SetupPinScreenState extends ConsumerState<SetupPinScreen> {
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  void _submit() {
    final pin = _pinController.text;
    final confirm = _confirmPinController.text;

    if (pin.length != 4 || !RegExp(r'^\d+$').hasMatch(pin)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN must be 4 digits')),
      );
      return;
    }

    if (pin != confirm) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PINs do not match')),
      );
      return;
    }

    ref.read(walletNotifierProvider.notifier).setupPin(pin);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    ref.listen<WalletState>(walletNotifierProvider, (prev, next) {
      next.maybeWhen(
        loaded: (wallet, hasPin) {
          if (hasPin) {
            context.pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PIN setup successful')),
            );
          }
        },
        error: (err) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
        },
        orElse: () {},
      );
    });

    final isLoading = ref.watch(walletNotifierProvider).maybeWhen(
      loading: () => true,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.setupPin)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.lock_outline, size: 64, color: AppTheme.primaryGreen),
              const SizedBox(height: 24),
              const Text(
                'Enter 4-digit PIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 16),
                decoration: const InputDecoration(counterText: ''),
              ),
              const SizedBox(height: 24),
              const Text(
                'Confirm PIN',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24, letterSpacing: 16),
                decoration: const InputDecoration(counterText: ''),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: isLoading 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Save PIN'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
