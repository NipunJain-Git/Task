// Jobs browser screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';
import 'job_card_widget.dart';

class JobsBrowserScreen extends StatefulWidget {
  const JobsBrowserScreen({super.key});

  @override
  State<JobsBrowserScreen> createState() => _JobsBrowserScreenState();
}

class _JobsBrowserScreenState extends State<JobsBrowserScreen> {
  String _filterSkill = 'all';
  String _sort = 'distance';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    var jobs = provider.feedJobs;
    if (_filterSkill != 'all') jobs = jobs.where((f) => f.job.category == _filterSkill).toList();
    if (_sort == 'distance') jobs.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    if (_sort == 'pay') jobs.sort((a, b) => b.job.budget.compareTo(a.job.budget));
    if (_sort == 'match') jobs.sort((a, b) => b.matchScore.compareTo(a.matchScore));

    return Column(
      children: [
        // Filters
        Container(
          color: AppTheme.card,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  ChipButton(label: 'All', selected: _filterSkill == 'all', onTap: () => setState(() { _filterSkill = 'all'; })),
                  const SizedBox(width: 8),
                  ...kSkills.take(6).map((s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChipButton(
                      label: s.label, selected: _filterSkill == s.key,
                      icon: KsText(s.emoji, style: const TextStyle(fontSize: 14)),
                      onTap: () => setState(() { _filterSkill = s.key; }),
                    ),
                  )),
                ]),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(children: [
                  KsText('Sort: ', style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.mutedForeground)),
                  for (final s in [
                    {'key': 'distance', 'label': 'Distance'},
                    {'key': 'pay', 'label': 'Pay'},
                    {'key': 'match', 'label': 'Best match'},
                  ]) Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChipButton(label: s['label']!, selected: _sort == s['key'], onTap: () => setState(() { _sort = s['key']!; })),
                  ),
                ]),
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: jobs.isEmpty
              ? const Center(child: EmptyState(title: 'No jobs found', body: 'Try clearing the filter or widening your search.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: jobs.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: JobCardWidget(feedJob: jobs[i], rank: i),
                  ),
                ),
        ),
      ],
    );
  }
}
