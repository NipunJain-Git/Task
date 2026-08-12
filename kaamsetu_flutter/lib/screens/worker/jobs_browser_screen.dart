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
  String _selectedCity = 'Delhi';

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
              // City Selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KsText('Nearby Jobs', style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.foreground)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCity,
                        icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primary),
                        isDense: true,
                        style: GoogleFonts.notoSans(color: AppTheme.primary, fontWeight: FontWeight.w700),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() { _selectedCity = newValue; });
                            // In a real app we'd trigger a reload with the new city.
                          }
                        },
                        items: ['Delhi', 'Mumbai', 'Bangalore'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: KsText(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

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
