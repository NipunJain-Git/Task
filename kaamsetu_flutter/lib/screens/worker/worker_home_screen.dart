// Worker home screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../core/i18n.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';
import 'job_card_widget.dart';

class WorkerHomeScreen extends StatelessWidget {
  const WorkerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user!;
    final profile = provider.workerProfile;
    final lang = provider.lang;
    String t(String key) => tr(lang, key);

    final trust = profile == null ? 0 : trustScore(
      thumbsUp: profile.thumbsUp, thumbsDown: profile.thumbsDown,
      jobsDone: profile.jobsDone, aadhaarVerified: user.aadhaarVerified,
      streak: user.streak,
    );

    final feed = provider.feedJobs;
    final inRadius = feed.where((f) => f.distanceKm <= user.radiusKm).toList();

    return RefreshIndicator(
      color: AppTheme.primary,
      onRefresh: () => provider.refreshJobs(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
        // Availability toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: profile?.availableNow == true ? AppTheme.success : AppTheme.border),
          ),
          child: Row(
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                KsText(profile?.availableNow == true ? t('availableNow') : t('offDuty'),
                    style: GoogleFonts.notoSans(fontSize: 15, fontWeight: FontWeight.w700,
                        color: profile?.availableNow == true ? AppTheme.success : AppTheme.foreground)),
                KsText('${profile?.availableFrom ?? '08:00'} – ${profile?.availableTo ?? '18:00'}',
                    style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
              ]),
              const Spacer(),
              Switch(
                value: profile?.availableNow ?? false,
                activeColor: AppTheme.success,
                onChanged: (_) => provider.toggleAvailability(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Stats grid
        Row(children: [
          for (final s in [
            {'icon': Icons.currency_rupee, 'val': '₹${user.walletBalance}', 'label': 'Earned', 'color': AppTheme.primary},
            {'icon': Icons.work_outline, 'val': '${profile?.jobsDone ?? 0}', 'label': 'Jobs done', 'color': AppTheme.primary},
            {'icon': Icons.local_fire_department, 'val': '${user.streak}d', 'label': 'Streak', 'color': AppTheme.accent},
          ]) ...[
            Expanded(child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(s['icon'] as IconData, size: 16, color: s['color'] as Color),
                const SizedBox(height: 6),
                KsText(s['val'] as String, style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w800, height: 1)),
                const SizedBox(height: 2),
                KsText(s['label'] as String, style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.mutedForeground, fontWeight: FontWeight.w500)),
              ]),
            )),
          ],
        ].toList()..removeLast()),
        const SizedBox(height: 16),

        // Trust score
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
          child: Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              KsText('Trust score', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
              Row(children: [
                const Icon(Icons.thumb_up, size: 12, color: AppTheme.mutedForeground),
                const SizedBox(width: 4),
                KsText('${profile?.thumbsUp ?? 0} good · ${profile?.thumbsDown ?? 0} bad',
                    style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
              ]),
            ]),
            const Spacer(),
            TrustMeter(score: trust),
          ]),
        ),
        const SizedBox(height: 16),

        // Badges
        if ((profile?.badges.length ?? 0) > 0) ...[
          SectionTitle(title: 'Your badges'),
          Wrap(spacing: 8, runSpacing: 8,
              children: profile!.badges.map((b) => BadgeChip(badge: b)).toList()),
          const SizedBox(height: 16),
        ],

        // Recommended jobs
        SectionTitle(
          title: 'Recommended · within ${user.radiusKm.round()} km',
          action: TextButton(
            onPressed: () => provider.setTab(1),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              KsText('All jobs', style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary)),
              const Icon(Icons.arrow_forward, size: 14, color: AppTheme.primary),
            ]),
          ),
        ),
        if (inRadius.isEmpty)
          EmptyState(
            title: 'No jobs in your radius yet',
            body: 'New jobs appear here as soon as households post them nearby.',
            action: ElevatedButton(onPressed: () => provider.setTab(4), child: const KsText('Widen radius')),
          )
        else
          ...inRadius.take(5).toList().asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: JobCardWidget(feedJob: e.value, rank: e.key),
          )),
        ],
      ),
    );
  }
}
