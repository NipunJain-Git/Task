// Profile screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../core/i18n.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';
import '../auth/onboarding_screen.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user!;
    final profile = provider.workerProfile;
    final isWorker = user.role == 'worker';
    final trust = profile == null
        ? 0
        : trustScore(
            thumbsUp: profile.thumbsUp,
            thumbsDown: profile.thumbsDown,
            jobsDone: profile.jobsDone,
            aadhaarVerified: user.aadhaarVerified,
            streak: user.streak,
          );

    final lang = provider.lang;
    String t(String key) => tr(lang, key);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Avatar + name
        Center(
          child: Column(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.3),
                    width: 3,
                  ),
                ),
                child: Center(
                  child: KsText(
                    user.name.isNotEmpty ? user.name[0] : '?',
                    style: GoogleFonts.notoSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  KsText(
                    user.name,
                    style: GoogleFonts.notoSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (user.aadhaarVerified)
                    const Icon(
                      Icons.verified,
                      color: AppTheme.primary,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: KsText(
                      isWorker ? '👷 Worker' : '🏠 Household',
                      style: GoogleFonts.notoSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.secondaryForeground,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => EditProfileScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.edit,
                            size: 12,
                            color: AppTheme.foreground,
                          ),
                          const SizedBox(width: 4),
                          KsText(
                            'Edit',
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => OnboardingScreen(
                  role: user.role,
                  lang: user.language,
                  phone: user.phone,
                  profileDetailsOnly: true,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primary,
                  AppTheme.primary.withValues(alpha: 0.78),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.auto_awesome, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KsText(
                        'Make your profile stand out',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      KsText(
                        'Add location, work preferences and safety details anytime.',
                        style: GoogleFonts.notoSans(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.82),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        if (!user.aadhaarVerified) ...[
          GestureDetector(
            onTap: () => _showIdentityVerification(context),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    color: AppTheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KsText(
                          'Verify your identity',
                          style: GoogleFonts.notoSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                          ),
                        ),
                        KsText(
                          'Build trust and get more matches',
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            color: AppTheme.mutedForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: AppTheme.primary),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],

        // Stats
        if (isWorker && profile != null) ...[
          Row(
            children: [
              for (final s in [
                {
                  'val': '${profile.thumbsUp}',
                  'label': 'Thumbs up',
                  'icon': Icons.thumb_up,
                  'color': AppTheme.success,
                },
                {
                  'val': '${profile.jobsDone}',
                  'label': 'Jobs done',
                  'icon': Icons.work,
                  'color': AppTheme.primary,
                },
                {
                  'val': '${user.streak}d',
                  'label': 'Streak',
                  'icon': Icons.local_fire_department,
                  'color': AppTheme.accent,
                },
              ])
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.card,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppTheme.border),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          s['icon'] as IconData,
                          size: 16,
                          color: s['color'] as Color,
                        ),
                        const SizedBox(height: 4),
                        KsText(
                          s['val'] as String,
                          style: GoogleFonts.notoSans(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        KsText(
                          s['label'] as String,
                          style: GoogleFonts.notoSans(
                            fontSize: 10,
                            color: AppTheme.mutedForeground,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          // Trust score
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                KsText(
                  'Trust score',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                TrustMeter(score: trust),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Badges
          if (profile.badges.isNotEmpty) ...[
            KsText(
              'Badges',
              style: GoogleFonts.notoSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile.badges.map((b) => BadgeChip(badge: b)).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // Skills
          KsText(
            'Skills',
            style: GoogleFonts.notoSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: profile.skills
                .map(
                  (s) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.secondary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SkillIcon(skill: s, size: 14),
                        const SizedBox(width: 6),
                        KsText(
                          skillLabel(s),
                          style: GoogleFonts.notoSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.secondaryForeground,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
        ],

        // User info
        KsText(
          'Account',
          style: GoogleFonts.notoSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.phone,
                size: 18,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: 12),
              KsText(
                'Phone',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: AppTheme.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              KsText(
                '+91 ${user.phone}',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 18,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: 12),
              KsText(
                'Area',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: AppTheme.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              KsText(
                user.area,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => SimpleDialog(
                title: const KsText('App language'),
                children: kLanguages.map((l) {
                  return SimpleDialogOption(
                    onPressed: () {
                      provider.setLang(l['code']!);
                      Navigator.pop(ctx);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          KsText(
                            l['native']!,
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          KsText(
                            '(${l['label']})',
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: AppTheme.mutedForeground,
                            ),
                          ),
                          const Spacer(),
                          if (provider.lang == l['code'])
                            const Icon(
                              Icons.check,
                              color: AppTheme.primary,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primary.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.language, size: 18, color: AppTheme.primary),
                const SizedBox(width: 12),
                KsText(
                  'App language',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: AppTheme.foreground,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                KsText(
                  kLanguages.firstWhere(
                    (l) => l['code'] == provider.lang,
                    orElse: () => kLanguages[0],
                  )['native']!,
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.chevron_right,
                  size: 16,
                  color: AppTheme.primary,
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.radar,
                size: 18,
                color: AppTheme.mutedForeground,
              ),
              const SizedBox(width: 12),
              KsText(
                'Radius',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: AppTheme.mutedForeground,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Spacer(),
              KsText(
                '${user.radiusKm.round()} km',
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (user.familyName != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.family_restroom,
                  size: 18,
                  color: AppTheme.mutedForeground,
                ),
                const SizedBox(width: 12),
                KsText(
                  'Family contact',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    color: AppTheme.mutedForeground,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                KsText(
                  '${user.familyName} (${user.familyRelation})',
                  style: GoogleFonts.notoSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 24),

        // KaamBot help
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/chatbot');
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppTheme.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.border),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.chat_bubble_outline,
                  size: 20,
                  color: AppTheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KsText(
                        t('chatbot'),
                        style: GoogleFonts.notoSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      KsText(
                        t('liveChat'),
                        style: GoogleFonts.notoSans(
                          fontSize: 13,
                          color: AppTheme.mutedForeground,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppTheme.mutedForeground,
                ),
              ],
            ),
          ),
        ),

        // Sign out
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<AppProvider>().signOut();
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/landing', (_) => false);
            },
            icon: const Icon(
              Icons.logout,
              size: 18,
              color: AppTheme.destructive,
            ),
            label: KsText(
              'Sign out',
              style: GoogleFonts.notoSans(
                color: AppTheme.destructive,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.destructive.withOpacity(0.4)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _showIdentityVerification(BuildContext context) {
    final controller = TextEditingController();
    String? error;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const KsText('Verify your identity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const KsText(
                'Demo: any 12-digit identity number will pass eKYC.',
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                maxLength: 12,
                decoration: InputDecoration(
                  hintText: '1234 5678 9012',
                  counterText: '',
                  errorText: error,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const KsText('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final identityNumber = controller.text.replaceAll(
                  RegExp(r'\D'),
                  '',
                );
                if (identityNumber.length != 12) {
                  setDialogState(() => error = 'Enter all 12 digits');
                  return;
                }
                context.read<AppProvider>().verifyIdentity(identityNumber);
                Navigator.pop(dialogContext);
              },
              child: const KsText('Verify'),
            ),
          ],
        ),
      ),
    ).whenComplete(controller.dispose);
  }
}
