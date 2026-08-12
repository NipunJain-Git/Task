// Login flow — mirrors components/auth/login-flow.tsx
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';

class LoginScreen extends StatefulWidget {
  final String? initialRole;
  const LoginScreen({super.key, this.initialRole});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _step = 'lang'; // lang | role | phone | otp
  String _lang = 'en';
  String _role = 'worker';
  String _phone = '';
  String _otp = '';
  bool _loading = false;
  String _error = '';

  final _phoneCtrl = TextEditingController();
  final _otpCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _lang = context.read<AppProvider>().lang;
    if (widget.initialRole != null) {
      _role = widget.initialRole!;
    }
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _otpCtrl.dispose();
    super.dispose();
  }

  String t(String key) => tr(context.watch<AppProvider>().lang, key);

  final List<String> _steps = ['lang', 'role', 'phone', 'otp'];
  int get _stepIdx => _steps.indexOf(_step);

  void _nextStep() async {
    final provider = context.read<AppProvider>();
    setState(() {
      _error = '';
    });

    if (_step == 'lang') {
      setState(() {
        _step = 'role';
      });
    } else if (_step == 'role') {
      setState(() {
        _step = 'phone';
      });
    } else if (_step == 'phone') {
      if (_phone.length != 10) return;
      setState(() {
        _loading = true;
      });
      await provider.requestOtp(_phone);
      if (mounted)
        setState(() {
          _loading = false;
          _step = 'otp';
        });
    } else if (_step == 'otp') {
      if (_otp.length != 6) return;
      setState(() {
        _loading = true;
      });
      final ok = await provider.verifyOtp(_phone, _otp, _role);
      if (!mounted) return;
      setState(() {
        _loading = false;
      });
      if (!ok) {
        setState(() {
          _error = provider.error ?? 'Verification failed';
        });
        return;
      }
      final user = provider.user!;
      if (!user.onboarded) {
        Navigator.of(context).pushReplacementNamed(
          '/onboarding',
          arguments: {
            'role': _role,
            'lang': _lang,
            'phone': _phone,
            'quickSignUp': true,
          },
        );
      } else {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  bool get _canAdvance {
    switch (_step) {
      case 'phone':
        return _phone.length == 10;
      case 'otp':
        return _otp.length == 6;
      default:
        return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 428),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(children: [const KaamSetuLogo()]),
                const SizedBox(height: 24),

                // Progress bar
                StepProgressBar(total: 4, current: _stepIdx),

                const SizedBox(height: 32),

                // Step content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_step == 'lang') _buildLangStep(),
                        if (_step == 'role') _buildRoleStep(),
                        if (_step == 'phone') _buildPhoneStep(),
                        if (_step == 'otp') _buildOtpStep(),

                        if (_error.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.destructive.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: KsText(
                              _error,
                              style: GoogleFonts.notoSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppTheme.destructive,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // CTA
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: KsPrimaryButton(
                    label: _step == 'phone'
                        ? t('sendOtp')
                        : _step == 'otp'
                        ? t('verify')
                        : t('continue'),
                    onTap: _canAdvance ? _nextStep : null,
                    isLoading: _loading,
                    icon: const Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLangStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText(
          t('chooseLanguage'),
          style: GoogleFonts.notoSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        KsText(
          t('chooseLanguageSub'),
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(height: 24),
        ...kLanguages.map((l) {
          final selected = _lang == l['code'];
          return GestureDetector(
            onTap: () {
              setState(() {
                _lang = l['code']!;
              });
              context.read<AppProvider>().setLang(l['code']!);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: selected ? AppTheme.primary : AppTheme.border,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KsText(
                          l['native']!,
                          style: GoogleFonts.notoSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        KsText(
                          l['code'] == 'en' ? 'English' : 'KaamSetu language',
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (selected)
                    const Icon(
                      Icons.verified_user,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildRoleStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText(
          t('iAmA'),
          style: GoogleFonts.notoSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        KsText(
          'You can switch later from your profile.',
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(height: 24),
        for (final r in [
          {
            'key': 'worker',
            'icon': Icons.construction,
            'title': t('worker'),
            'sub': t('workerSub'),
          },
          {
            'key': 'household',
            'icon': Icons.home,
            'title': t('household'),
            'sub': t('householdSub'),
          },
        ])
          GestureDetector(
            onTap: () => setState(() {
              _role = r['key'] as String;
            }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _role == r['key'] ? AppTheme.primary : AppTheme.border,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _role == r['key']
                          ? AppTheme.primary
                          : AppTheme.muted,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      r['icon'] as IconData,
                      color: _role == r['key']
                          ? Colors.white
                          : AppTheme.foreground,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KsText(
                          r['title'] as String,
                          style: GoogleFonts.notoSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        KsText(
                          r['sub'] as String,
                          style: GoogleFonts.notoSans(
                            fontSize: 13,
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPhoneStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText(
          t('phoneNumber'),
          style: GoogleFonts.notoSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        KsText(
          "We send a one-time code to confirm it's you.",
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: AppTheme.mutedForeground,
          ),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppTheme.border, width: 2),
          ),
          child: Row(
            children: [
              const Icon(Icons.phone, color: AppTheme.mutedForeground),
              const SizedBox(width: 8),
              KsText(
                '+91',
                style: GoogleFonts.notoSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.mutedForeground,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (v) => setState(() {
                    _phone = v.replaceAll(RegExp(r'\D'), '');
                  }),
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '98765 43210',
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                    fillColor: Colors.transparent,
                    filled: false,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.secondary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: KsText(
            'Demo mode: any 10-digit number works and the OTP is always 123456.',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: AppTheme.secondaryForeground,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText(
          t('enterOtp'),
          style: GoogleFonts.notoSans(
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: AppTheme.mutedForeground,
            ),
            children: [
              TextSpan(text: '${t('Sent to ')} '),
              TextSpan(
                text: '+91 $_phone',
                style: GoogleFonts.notoSans(
                  color: AppTheme.foreground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _otpCtrl,
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          onChanged: (v) => setState(() {
            _otp = v.replaceAll(RegExp(r'\D'), '');
          }),
          style: GoogleFonts.notoSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 16,
          ),
          decoration: InputDecoration(
            hintText: '······',
            counterText: '',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppTheme.border, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            setState(() {
              _otp = '123456';
            });
            _otpCtrl.text = '123456';
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppTheme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: KsText(
              'Autofill demo OTP 123456',
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.secondaryForeground,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
