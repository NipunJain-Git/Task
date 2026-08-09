// Onboarding wizard — mirrors components/auth/onboarding-wizard.tsx
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../core/i18n.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';

class OnboardingScreen extends StatefulWidget {
  final String role;
  final String lang;
  final String phone;
  const OnboardingScreen({super.key, required this.role, required this.lang, required this.phone});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late String _lang;
  int _step = 0;
  bool _loading = false;
  String _error = '';

  // Form state
  String _name = '';
  String _area = kAreas[0]['name'] as String;
  double _radiusKm = 5.0;
  String _aadhaar = '';
  String _aadhaarOtp = '';
  bool _aadhaarVerified = false;
  int _aadhaarStep = 1; // 1: input, 2: otp, 3: success
  bool _verifying = false;
  List<String> _skills = [];
  int _wage = 600;
  String _wageUnit = 'day';
  int _experience = 2;
  String _bio = '';
  String _availFrom = '08:00';
  String _availTo = '18:00';
  String _familyName = '';
  String _familyPhone = '';
  String _familyRelation = kRelations[0];
  String _pin = '';
  String _pin2 = '';

  List<String> get _stepIds => widget.role == 'worker'
      ? ['identity', 'area', 'aadhaar', 'skills', 'availability', 'family', 'pin']
      : ['identity', 'area', 'aadhaar', 'family', 'pin'];

  String get _current => _stepIds[_step];
  bool get _isLast => _step == _stepIds.length - 1;

  @override
  void initState() {
    super.initState();
    _lang = widget.lang;
  }

  String t(String key) => tr(_lang, key);

  bool get _canAdvance {
    switch (_current) {
      case 'identity': return _name.trim().length >= 2;
      case 'area': return true;
      case 'aadhaar': return true;
      case 'skills': return _skills.isNotEmpty;
      case 'availability': return true;
      case 'family': return _familyName.trim().length >= 2 && _familyPhone.replaceAll(RegExp(r'\D'), '').length == 10;
      case 'pin': return RegExp(r'^\d{4}$').hasMatch(_pin) && _pin == _pin2;
      default: return true;
    }
  }

  void _verifyAadhaar() {
    if (_aadhaarStep == 1) {
      if (_aadhaar.replaceAll(RegExp(r'\D'), '').length != 12) {
        setState(() { _error = 'Aadhaar number must be 12 digits'; });
        return;
      }
      setState(() { _verifying = true; _error = ''; });
      // Simulate OTP generation
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() { _verifying = false; _aadhaarStep = 2; });
      });
    } else if (_aadhaarStep == 2) {
      if (_aadhaarOtp.length != 6) {
        setState(() { _error = 'OTP must be 6 digits'; });
        return;
      }
      setState(() { _verifying = true; _error = ''; });
      // Simulate OTP verification and eKYC fetch
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) setState(() { _verifying = false; _aadhaarStep = 3; _aadhaarVerified = true; });
      });
    } else if (_aadhaarStep == 3) {
      // Allow proceeding
      setState(() { _step++; });
    }
  }

  Future<void> _submit() async {
    setState(() { _loading = true; _error = ''; });
    final provider = context.read<AppProvider>();
    await provider.completeOnboarding(
      name: _name,
      role: widget.role,
      language: _lang,
      area: _area,
      familyName: _familyName,
      familyPhone: _familyPhone,
      familyRelation: _familyRelation,
      aadhaarVerified: _aadhaarVerified,
      aadhaarLast4: _aadhaarVerified ? _aadhaar.replaceAll(RegExp(r'\D'), '').substring(8) : null,
      pin: _pin,
      radiusKm: _radiusKm,
      skills: _skills,
      expectedWage: _wage,
      wageUnit: _wageUnit,
      experienceYears: _experience,
      bio: _bio,
      availableFrom: _availFrom,
      availableTo: _availTo,
    );
    if (mounted) {
      setState(() { _loading = false; });
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
          child: Column(
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (_step > 0) setState(() { _step--; });
                      else Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 40, height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.card, borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: const Icon(Icons.arrow_back, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const KaamSetuLogo(),
                  const Spacer(),
                  KsText('${_step + 1}/${_stepIds.length}',
                      style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.mutedForeground)),
                ],
              ),
              const SizedBox(height: 24),
              StepProgressBar(total: _stepIds.length, current: _step),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_current == 'identity') _buildIdentity(),
                      if (_current == 'area') _buildArea(),
                      if (_current == 'aadhaar') _buildAadhaar(),
                      if (_current == 'skills') _buildSkills(),
                      if (_current == 'availability') _buildAvailability(),
                      if (_current == 'family') _buildFamily(),
                      if (_current == 'pin') _buildPin(),
                      if (_error.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppTheme.destructive.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: KsText(_error, style: GoogleFonts.notoSans(color: AppTheme.destructive, fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  children: [
                    if (_current == 'aadhaar' && !_aadhaarVerified) ...[
                      Expanded(
                        flex: 0,
                        child: TextButton(
                          onPressed: () => setState(() { _step++; }),
                          child: KsText(t('skip'), style: GoogleFonts.notoSans(color: AppTheme.mutedForeground, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Expanded(
                      child: KsPrimaryButton(
                        label: _isLast ? 'Finish setup' : (_current == 'aadhaar' && _aadhaarStep < 3 ? 'Continue' : t('continue')),
                        onTap: _canAdvance ? (_isLast ? _submit : (_current == 'aadhaar' && _aadhaarStep < 3 ? _verifyAadhaar : () => setState(() { _step++; }))) : null,
                        isLoading: _loading || _verifying,
                        icon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                      ),
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

  Widget _buildIdentity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText("What should we call you?", style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        KsText("This is the name households and workers will see.", style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground)),
        const SizedBox(height: 24),
        TextField(
          onChanged: (v) => setState(() { _name = v; }),
          decoration: InputDecoration(hintText: 'Full name', prefixIcon: const Icon(Icons.person_outline)),
          style: GoogleFonts.notoSans(fontSize: 17, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        KsText('Signed in as +91 ${widget.phone}',
            style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
        const SizedBox(height: 24),
        KsText('App language', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: kLanguages.map((l) => ChipButton(
            label: l['native']!,
            selected: _lang == l['code'],
            onTap: () => setState(() { _lang = l['code']!; }),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText("Where are you based?", style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        KsText(widget.role == 'worker' ? "We only show you jobs inside your travel radius." : "We only show you workers who can reach you.",
            style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground)),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true, crossAxisCount: 2, childAspectRatio: 3, mainAxisSpacing: 8, crossAxisSpacing: 8,
          physics: const NeverScrollableScrollPhysics(),
          children: kAreas.map((a) {
            final name = a['name'] as String;
            final selected = _area == name;
            return GestureDetector(
              onTap: () => setState(() { _area = name; }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: selected ? AppTheme.primary : AppTheme.border, width: 2),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: selected ? AppTheme.primary : AppTheme.mutedForeground),
                    const SizedBox(width: 6),
                    Expanded(child: KsText(name, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KsText('Travel radius', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600)),
                  KsText('${_radiusKm.round()} km', style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                ],
              ),
              Slider(value: _radiusKm, min: 1, max: 15, divisions: 14, activeColor: AppTheme.primary,
                  onChanged: (v) => setState(() { _radiusKm = v; })),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KsText('1 km', style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.mutedForeground)),
                  KsText('15 km', style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.mutedForeground)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAadhaar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText(t('aadhaarVerify'), style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        KsText("Verified users get 3x more matches. We store only the last 4 digits.",
            style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground)),
        const SizedBox(height: 24),
        
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, animation) => FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation), child: child)),
          child: _aadhaarStep == 1
            ? _buildAadhaarInput()
            : _aadhaarStep == 2 
              ? _buildAadhaarOtp()
              : _buildAadhaarSuccess(),
        ),
      ],
    );
  }

  Widget _buildAadhaarInput() {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          keyboardType: TextInputType.number,
          maxLength: 14,
          onChanged: (v) {
            final d = v.replaceAll(RegExp(r'\D'), '').substring(0, v.replaceAll(RegExp(r'\D'), '').length.clamp(0, 12));
            setState(() { _aadhaar = d; });
          },
          decoration: InputDecoration(
            hintText: '1234 5678 9012', 
            counterText: '',
            prefixIcon: const Icon(Icons.credit_card),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppTheme.border, width: 2)),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
          style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w700, letterSpacing: 4),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, size: 16, color: AppTheme.secondaryForeground),
              const SizedBox(width: 8),
              Expanded(
                child: KsText('Demo: any 12 digits will pass this simulated eKYC check. You can also skip and verify later.',
                    style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.secondaryForeground, height: 1.4)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAadhaarOtp() {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
          child: Row(
            children: [
              const Icon(Icons.mark_email_read_outlined, color: AppTheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: KsText('OTP sent to the mobile number registered with your Aadhaar.', style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w500)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        KsText('Enter OTP', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        TextField(
          keyboardType: TextInputType.number,
          maxLength: 6,
          textAlign: TextAlign.center,
          onChanged: (v) {
            setState(() { _aadhaarOtp = v.replaceAll(RegExp(r'\D'), ''); });
          },
          decoration: InputDecoration(
            hintText: '••••••', 
            counterText: '',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: AppTheme.border, width: 2)),
            contentPadding: const EdgeInsets.symmetric(vertical: 20),
          ),
          style: GoogleFonts.notoSans(fontSize: 28, fontWeight: FontWeight.w800, letterSpacing: 16),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => setState(() { _aadhaarStep = 1; _aadhaarOtp = ''; }),
          child: KsText('Change Aadhaar Number', style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.primary)),
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
            child: const Icon(Icons.verified, color: AppTheme.success, size: 64),
          ),
          const SizedBox(height: 16),
          KsText('Identity Verified', style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.success)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppTheme.success.withValues(alpha: 0.5))),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.credit_card, size: 14, color: AppTheme.success),
                const SizedBox(width: 8),
                KsText('XXXX XXXX ${_aadhaar.replaceAll(RegExp(r'\D'), '').substring(8)}',
                    style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.success)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText("What work can you do?", style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        KsText("Pick everything that applies.", style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground)),
        const SizedBox(height: 24),
        GridView.count(
          shrinkWrap: true, crossAxisCount: 2, childAspectRatio: 2.8,
          mainAxisSpacing: 8, crossAxisSpacing: 8, physics: const NeverScrollableScrollPhysics(),
          children: kSkills.map((s) {
            final on = _skills.contains(s.key);
            return GestureDetector(
              onTap: () => setState(() { on ? _skills.remove(s.key) : _skills.add(s.key); }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: on ? AppTheme.primary.withOpacity(0.08) : AppTheme.card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: on ? AppTheme.primary : AppTheme.border, width: 2),
                ),
                child: Row(
                  children: [
                    KsText(s.emoji, style: const TextStyle(fontSize: 16)),
                    const SizedBox(width: 8),
                    Expanded(child: KsText(s.label, style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w600, color: on ? AppTheme.primary : AppTheme.foreground), overflow: TextOverflow.ellipsis)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                KsText('Expected wage', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600)),
                KsText('₹$_wage/$_wageUnit', style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.primary)),
              ]),
              Slider(
                value: _wage.toDouble(),
                min: _wageUnit == 'day' ? 200 : 40,
                max: _wageUnit == 'day' ? 2000 : 300,
                divisions: _wageUnit == 'day' ? 36 : 26,
                activeColor: AppTheme.primary,
                onChanged: (v) => setState(() { _wage = v.round(); }),
              ),
              Row(children: [
                for (final u in ['day', 'hour'])
                  Expanded(child: GestureDetector(
                    onTap: () => setState(() { _wageUnit = u; _wage = u == 'day' ? 600 : 80; }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.only(right: u == 'day' ? 4 : 0),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: _wageUnit == u ? AppTheme.primary.withOpacity(0.1) : AppTheme.card,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _wageUnit == u ? AppTheme.primary : AppTheme.border, width: 2),
                      ),
                      child: KsText('per $u', textAlign: TextAlign.center, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w700, color: _wageUnit == u ? AppTheme.primary : AppTheme.foreground)),
                    ),
                  )),
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailability() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText("When can you work?", style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        KsText("Households see these hours on your profile.", style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground)),
        const SizedBox(height: 24),
        Row(
          children: [
            for (final f in [
              {'label': 'From', 'value': _availFrom, 'isFrom': true},
              {'label': 'To', 'value': _availTo, 'isFrom': false},
            ]) ...[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KsText(f['label'] as String, style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.mutedForeground, letterSpacing: 0.5)),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border, width: 2)),
                      child: Row(children: [
                        const Icon(Icons.access_time, size: 16, color: AppTheme.mutedForeground),
                        const SizedBox(width: 8),
                        KsText(f['value'] as String, style: GoogleFonts.notoSans(fontSize: 15, fontWeight: FontWeight.w700)),
                      ]),
                    ),
                  ],
                ),
              ),
              if (f['isFrom'] == true) const SizedBox(width: 12),
            ],
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                KsText('Years of experience', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600)),
                KsText('$_experience', style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.primary)),
              ]),
              Slider(value: _experience.toDouble(), min: 0, max: 30, divisions: 30, activeColor: AppTheme.primary,
                  onChanged: (v) => setState(() { _experience = v.round(); })),
            ],
          ),
        ),
        const SizedBox(height: 16),
        TextField(
          maxLines: 3,
          onChanged: (v) => setState(() { _bio = v; }),
          decoration: const InputDecoration(hintText: 'e.g. 8 years of house painting. I bring my own tools.', labelText: 'About your work (optional)'),
        ),
      ],
    );
  }

  Widget _buildFamily() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText(t('familyContact'), style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Icon(Icons.shield_outlined, size: 16, color: AppTheme.accentForeground),
          const SizedBox(width: 8),
          Expanded(child: KsText("Every job you take or post sends this person an SMS with the address and time.",
              style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground, height: 1.5))),
        ]),
        const SizedBox(height: 24),
        TextField(onChanged: (v) => setState(() { _familyName = v; }), decoration: const InputDecoration(hintText: 'Contact name')),
        const SizedBox(height: 12),
        TextField(keyboardType: TextInputType.phone, maxLength: 10,
            onChanged: (v) => setState(() { _familyPhone = v.replaceAll(RegExp(r'\D'), ''); }),
            decoration: const InputDecoration(hintText: '98765 43210', prefixText: '+91  ', counterText: '')),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: kRelations.map((r) => ChipButton(
            label: r, selected: _familyRelation == r,
            onTap: () => setState(() { _familyRelation = r; }),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildPin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        KsText(t('setPin'), style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        KsText("Your earnings and payments are protected by this PIN.", style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground)),
        const SizedBox(height: 24),
        for (final f in [
          {'label': 'New PIN', 'isFirst': true},
          {'label': 'Confirm PIN', 'isFirst': false},
        ]) ...[
          KsText(f['label'] as String, style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.mutedForeground, letterSpacing: 0.5)),
          const SizedBox(height: 6),
          TextField(
            keyboardType: TextInputType.number, maxLength: 4, obscureText: true,
            textAlign: TextAlign.center,
            onChanged: (v) {
              final clean = v.replaceAll(RegExp(r'\D'), '');
              if (f['isFirst'] == true) setState(() { _pin = clean; });
              else setState(() { _pin2 = clean; });
            },
            decoration: InputDecoration(
              hintText: '••••', counterText: '',
              prefixIcon: const Icon(Icons.lock_outline, size: 18),
            ),
            style: GoogleFonts.notoSans(fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: 16),
          ),
          const SizedBox(height: 12),
        ],
        if (_pin2.length == 4 && _pin != _pin2)
          KsText('PINs do not match', style: GoogleFonts.notoSans(color: AppTheme.destructive, fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
