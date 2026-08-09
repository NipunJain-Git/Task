// Profile screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user!;
    final profile = provider.workerProfile;
    final isWorker = user.role == 'worker';
    final trust = profile == null ? 0 : trustScore(
      thumbsUp: profile.thumbsUp, thumbsDown: profile.thumbsDown,
      jobsDone: profile.jobsDone, aadhaarVerified: user.aadhaarVerified, streak: user.streak,
    );

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Avatar + name
        Center(
          child: Column(children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.12), shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primary.withValues(alpha: 0.3), width: 3)),
              child: Center(child: KsText(user.name.isNotEmpty ? user.name[0] : '?',
                  style: GoogleFonts.notoSans(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.primary))),
            ),
            const SizedBox(height: 12),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              KsText(user.name, style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w800)),
              const SizedBox(width: 6),
              if (user.aadhaarVerified) const Icon(Icons.verified, color: AppTheme.primary, size: 20),
            ]),
            const SizedBox(height: 8),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(999)),
                child: KsText(isWorker ? '👷 Worker' : '🏠 Household',
                    style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.secondaryForeground)),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => EditProfileScreen()));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(999), border: Border.all(color: AppTheme.border)),
                  child: Row(children: [
                    const Icon(Icons.edit, size: 12, color: AppTheme.foreground),
                    const SizedBox(width: 4),
                    KsText('Edit', style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
            ]),
          ]),
        ),
        const SizedBox(height: 24),

        // Stats
        if (isWorker && profile != null) ...[
          Row(children: [
            for (final s in [
              {'val': '${profile.thumbsUp}', 'label': 'Thumbs up', 'icon': Icons.thumb_up, 'color': AppTheme.success},
              {'val': '${profile.jobsDone}', 'label': 'Jobs done', 'icon': Icons.work, 'color': AppTheme.primary},
              {'val': '${user.streak}d', 'label': 'Streak', 'icon': Icons.local_fire_department, 'color': AppTheme.accent},
            ]) Expanded(child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
              child: Column(children: [
                Icon(s['icon'] as IconData, size: 16, color: s['color'] as Color),
                const SizedBox(height: 4),
                KsText(s['val'] as String, style: GoogleFonts.notoSans(fontSize: 17, fontWeight: FontWeight.w800)),
                KsText(s['label'] as String, style: GoogleFonts.notoSans(fontSize: 10, color: AppTheme.mutedForeground), textAlign: TextAlign.center),
              ]),
            )),
          ]),
          const SizedBox(height: 16),

          // Trust score
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
            child: Row(children: [
              KsText('Trust score', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
              const Spacer(),
              TrustMeter(score: trust),
            ]),
          ),
          const SizedBox(height: 16),

          // Badges
          if (profile.badges.isNotEmpty) ...[
            KsText('Badges', style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Wrap(spacing: 8, runSpacing: 8, children: profile.badges.map((b) => BadgeChip(badge: b)).toList()),
            const SizedBox(height: 20),
          ],

          // Skills
          KsText('Skills', style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Wrap(spacing: 8, runSpacing: 8,
            children: profile.skills.map((s) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(8)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                SkillIcon(skill: s, size: 14),
                const SizedBox(width: 6),
                KsText(skillLabel(s), style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.secondaryForeground)),
              ]),
            )).toList(),
          ),
          const SizedBox(height: 20),
        ],

        // User info
        KsText('Account', style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        for (final row in [
          {'icon': Icons.phone, 'label': 'Phone', 'val': '+91 ${user.phone}'},
          {'icon': Icons.location_on_outlined, 'label': 'Area', 'val': user.area},
          {'icon': Icons.language, 'label': 'Language', 'val': user.language.toUpperCase()},
          {'icon': Icons.radar, 'label': 'Radius', 'val': '${user.radiusKm.round()} km'},
          if (user.familyName != null) {'icon': Icons.family_restroom, 'label': 'Family contact', 'val': '${user.familyName} (${user.familyRelation})'},
        ]) Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
          child: Row(children: [
            Icon(row['icon'] as IconData, size: 18, color: AppTheme.mutedForeground),
            const SizedBox(width: 12),
            KsText(row['label'] as String, style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground, fontWeight: FontWeight.w500)),
            const Spacer(),
            KsText(row['val'] as String, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w700)),
          ]),
        ),

        const SizedBox(height: 24),

        // Sign out
        SizedBox(
          width: double.infinity, height: 48,
          child: OutlinedButton.icon(
            onPressed: () {
              context.read<AppProvider>().signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/landing', (_) => false);
            },
            icon: const Icon(Icons.logout, size: 18, color: AppTheme.destructive),
            label: KsText('Sign out', style: GoogleFonts.notoSans(color: AppTheme.destructive, fontWeight: FontWeight.w700)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.destructive.withOpacity(0.4)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
