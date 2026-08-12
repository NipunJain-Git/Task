// Workers browser screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';

class WorkersBrowserScreen extends StatefulWidget {
  const WorkersBrowserScreen({super.key});

  @override
  State<WorkersBrowserScreen> createState() => _WorkersBrowserScreenState();
}

class _WorkersBrowserScreenState extends State<WorkersBrowserScreen> {
  String _filterSkill = 'all';
  bool _onlyAvailable = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    var workers = provider.nearbyWorkers;
    if (_onlyAvailable) workers = workers.where((w) => w.availableNow).toList();
    if (_filterSkill != 'all') workers = workers.where((w) => w.skills.contains(_filterSkill)).toList();

    return Column(
      children: [
        Container(
          color: AppTheme.card,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ChipButton(label: 'All skills', selected: _filterSkill == 'all', onTap: () => setState(() { _filterSkill = 'all'; })),
                  const SizedBox(width: 8),
                  ...kSkills.take(5).map((s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChipButton(
                      label: s.label, selected: _filterSkill == s.key,
                      icon: KsText(s.emoji, style: const TextStyle(fontSize: 13)),
                      onTap: () => setState(() { _filterSkill = s.key; }),
                    ),
                  )),
                ]),
              ),
              const SizedBox(height: 8),
              Row(children: [
                Checkbox(value: _onlyAvailable, activeColor: AppTheme.primary, onChanged: (v) => setState(() { _onlyAvailable = v!; })),
                KsText('Available now only', style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600)),
              ]),
            ],
          ),
        ),
        Expanded(
          child: workers.isEmpty
              ? const Center(child: EmptyState(title: 'No workers found', body: 'Try removing filters or check back later.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: workers.length,
                  itemBuilder: (_, i) {
                    final w = workers[i];
                    final trust = trustScore(thumbsUp: w.thumbsUp, thumbsDown: w.thumbsDown, jobsDone: w.jobsDone, aadhaarVerified: w.aadhaarVerified, streak: 0);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
                      child: Column(
                        children: [
                          Row(children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(color: AppTheme.secondary, shape: BoxShape.circle),
                              child: Center(child: KsText(w.name[0], style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w800, color: AppTheme.primary))),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                KsText(w.name, style: GoogleFonts.notoSans(fontSize: 15, fontWeight: FontWeight.w700)),
                                const SizedBox(width: 4),
                                VerifiedBadge(verified: w.aadhaarVerified),
                                const SizedBox(width: 6),
                                if (w.availableNow) ...[const LiveDot(), const SizedBox(width: 4), KsText('Live', style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.success))],
                              ]),
                              KsText('₹${w.expectedWage}/${w.wageUnit} · ${w.jobsDone} jobs done',
                                  style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
                            ])),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              TrustMeter(score: trust),
                              const SizedBox(height: 4),
                              DistanceChip(km: w.distanceKm),
                            ]),
                          ]),
                          const SizedBox(height: 12),
                          Wrap(spacing: 6, runSpacing: 6,
                              children: w.skills.map((s) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(8)),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  SkillIcon(skill: s, size: 13),
                                  const SizedBox(width: 4),
                                  KsText(skillLabel(s), style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.secondaryForeground)),
                                ]),
                              )).toList()),
                          const SizedBox(height: 12),
                          SizedBox(width: double.infinity, height: 40, child: ElevatedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: KsText('Hiring flow initiated for ${w.name}')),
                              );
                            },
                            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                            child: const KsText('Hire now'),
                          )),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
