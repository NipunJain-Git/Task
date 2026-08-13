import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:kaamsetu_flutter/core/theme.dart';
import 'package:kaamsetu_flutter/providers/app_provider.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  String _aadhaar = '';
  int _aadhaarStep = 1; // 1: input, 3: verified
  bool _verifying = false;
  String _error = '';

  void _verifyAadhaar() {
    if (_aadhaarStep == 1) {
      if (_aadhaar.replaceAll(RegExp(r'\D'), '').length != 12) {
        setState(() {
          _error = 'Aadhaar number must be 12 digits';
        });
        return;
      }
      setState(() {
        _verifying = true;
        _error = '';
      });
      // Demo eKYC
      Future.delayed(const Duration(milliseconds: 900), () async {
        if (!mounted) return;
        
        await context.read<AppProvider>().verifyIdentity(_aadhaar);
        
        if (!mounted) return;
        setState(() {
          _verifying = false;
          _aadhaarStep = 3;
        });
      });
    } else if (_aadhaarStep == 3) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Identity'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.05, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: _aadhaarStep == 1
                    ? _buildAadhaarInput()
                    : _buildAadhaarSuccess(),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _verifying ? null : _verifyAadhaar,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _verifying 
                    ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(_aadhaarStep == 3 ? 'Done' : 'Verify identity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAadhaarInput() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Verified users get 3x more matches. We store only the last 4 digits.",
          style: TextStyle(
            fontSize: 14,
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(height: 32),
        TextField(
          keyboardType: TextInputType.number,
          maxLength: 14,
          onChanged: (v) {
            final d = v
                .replaceAll(RegExp(r'\D'), '')
                .substring(
                  0,
                  v.replaceAll(RegExp(r'\D'), '').length.clamp(0, 12),
                );
            setState(() {
              _aadhaar = d;
              _error = '';
            });
          },
          decoration: InputDecoration(
            hintText: '1234 5678 9012',
            counterText: '',
            prefixIcon: const Icon(Icons.credit_card),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
          ),
        ),
        if (_error.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(_error, style: const TextStyle(color: AppTheme.destructive, fontWeight: FontWeight.bold)),
        ],
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.info_outline,
                size: 16,
                color: AppTheme.secondaryForeground,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Demo: any 12 digits will pass this eKYC check.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.secondaryForeground,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAadhaarSuccess() {
    return Container(
      key: const ValueKey(3),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: AppTheme.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.success, width: 2),
      ),
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: const Icon(
              Icons.verified,
              color: AppTheme.success,
              size: 64,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Identity Verified',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.success,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppTheme.success.withValues(alpha: 0.5),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.credit_card,
                  size: 14,
                  color: AppTheme.success,
                ),
                const SizedBox(width: 8),
                Text(
                  'XXXX XXXX ${_aadhaar.replaceAll(RegExp(r'\D'), '').padRight(12, '0').substring(8)}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
