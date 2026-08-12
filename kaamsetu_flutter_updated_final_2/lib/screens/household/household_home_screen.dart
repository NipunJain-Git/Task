// Household home screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';

class HouseholdHomeScreen extends StatelessWidget {
  const HouseholdHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user!;
    final myJobs = provider.myJobs;
    final workers = provider.nearbyWorkers;
    final liveWorkers = workers.where((w) => w.availableNow && w.distanceKm <= user.radiusKm).take(4).toList();
    final activeJobs = myJobs.where((j) => j.status != 'completed' && j.status != 'cancelled').toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Promo card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              KsText('Need help today?', style: GoogleFonts.notoSans(fontSize: 13, color: Colors.white.withOpacity(0.9))),
              const SizedBox(height: 4),
              KsText('Post a job and get replies in minutes', style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white, height: 1.3)),
              const SizedBox(height: 16),
              Row(children: [
                Expanded(child: SizedBox(height: 44, child: ElevatedButton.icon(
                  onPressed: () => provider.setTab(2),
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const KsText('Post a job'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, foregroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ))),
                const SizedBox(width: 8),
                Expanded(child: SizedBox(height: 44, child: OutlinedButton.icon(
                  onPressed: () => provider.setTab(1),
                  icon: const Icon(Icons.people_outline, size: 16, color: Colors.white),
                  label: const KsText('Browse', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ))),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Skills grid
        GridView.count(
          shrinkWrap: true, crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8,
          childAspectRatio: 0.85, physics: const NeverScrollableScrollPhysics(),
          children: kSkills.take(6).map((s) => Container(
            decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(10)),
                child: Center(child: SkillIcon(skill: s.key, size: 18)),
              ),
              const SizedBox(height: 6),
              KsText(s.label, textAlign: TextAlign.center, style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
            ]),
          )).toList(),
        ),
        const SizedBox(height: 20),

        // Live workers
        SectionTitle(
          title: 'Available right now',
          action: TextButton(
            onPressed: () => provider.setTab(3),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              KsText('See map', style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary)),
              const Icon(Icons.arrow_forward, size: 14, color: AppTheme.primary),
            ]),
          ),
        ),
        if (liveWorkers.isEmpty)
          const EmptyState(icon: Icons.bolt, title: 'No one is on duty nearby', body: 'Post a job instead and workers will reply as soon as they come online.')
        else
          ...liveWorkers.map((w) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: AppTheme.secondary, shape: BoxShape.circle),
                child: Center(child: KsText(w.name[0], style: GoogleFonts.notoSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.primary))),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  KsText(w.name, style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
                  const SizedBox(width: 4),
                  VerifiedBadge(verified: w.aadhaarVerified),
                  const SizedBox(width: 4),
                  const LiveDot(),
                ]),
                KsText('${w.skills.take(2).map(skillLabel).join(', ')} · ₹${w.expectedWage}/${w.wageUnit}',
                    style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
              ])),
              DistanceChip(km: w.distanceKm),
            ]),
          )),
        const SizedBox(height: 20),

        // My jobs
        SectionTitle(
          title: 'Your jobs',
          action: KsText('${myJobs.length} total', style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.mutedForeground)),
        ),
        if (activeJobs.isEmpty)
          EmptyState(
            title: 'No active jobs',
            body: 'Post a one-day job with your budget and date.',
            action: ElevatedButton(
              onPressed: () => provider.setTab(2),
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const KsText('Post a job'),
            ),
          )
        else
          ...activeJobs.map((job) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
            child: Row(children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(10)),
                child: Center(child: SkillIcon(skill: job.category, size: 20)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                KsText(job.title, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                KsText('${skillLabel(job.category)} · ${job.jobDate} · ₹${job.budget}',
                    style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
              ])),
              StatusPill(status: job.status),
            ]),
          )),

        // Wallet
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
          child: Row(children: [
            Container(width: 40, height: 40, decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.account_balance_wallet_outlined, color: AppTheme.primary, size: 20)),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              KsText('Wallet', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
              KsText('Pay workers straight from the app', style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
            ])),
            KsText('₹${user.walletBalance}', style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w800)),
          ]),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
