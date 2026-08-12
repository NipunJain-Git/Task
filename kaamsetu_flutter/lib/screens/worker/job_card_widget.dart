// Job card widget — mirrors components/kaam/job-card.tsx
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../data/models.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';

String _dateLabel(String iso) {
  final d = DateTime.tryParse('${iso}T00:00:00') ?? DateTime.now();
  final today = DateTime.now();
  final diff = d.difference(DateTime(today.year, today.month, today.day)).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  return '${['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][d.weekday - 1]}, ${d.day} ${['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'][d.month - 1]}';
}

class JobCardWidget extends StatefulWidget {
  final FeedJob feedJob;
  final int rank;
  const JobCardWidget({super.key, required this.feedJob, this.rank = 99});

  @override
  State<JobCardWidget> createState() => _JobCardWidgetState();
}

class _JobCardWidgetState extends State<JobCardWidget> {
  bool _expanded = false;
  bool _loading = false;
  late String? _interest;
  late int _quote;
  // ignore: unused_field
  String _note = '';

  @override
  void initState() {
    super.initState();
    _interest = widget.feedJob.myInterest;
    _quote = widget.feedJob.job.budget;
  }

  bool get _isTop => widget.rank == 0 && widget.feedJob.matchScore >= 60;

  Future<void> _apply() async {
    setState(() { _loading = true; });
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      context.read<AppProvider>().expressInterest(widget.feedJob.job.id);
      setState(() { _loading = false; _expanded = false; _interest = 'interested'; });
    }
  }

  Future<void> _pull() async {
    setState(() { _loading = true; });
    await Future.delayed(const Duration(milliseconds: 400));
    if (mounted) {
      context.read<AppProvider>().withdrawInterest(widget.feedJob.job.id);
      setState(() { _loading = false; _interest = null; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.feedJob.job;
    final household = widget.feedJob.household;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _isTop ? AppTheme.primary.withOpacity(0.4) : AppTheme.border, width: _isTop ? 2 : 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isTop) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
              child: KsText('Best match for you', style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w800, color: AppTheme.primary, letterSpacing: 0.5)),
            ),
            const SizedBox(height: 10),
          ],
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(12)),
              child: Center(child: SkillIcon(skill: job.category, size: 22)),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              KsText(job.title, style: GoogleFonts.notoSans(fontSize: 15, fontWeight: FontWeight.w700, height: 1.3)),
              const SizedBox(height: 2),
              Row(children: [
                KsText(skillLabel(job.category), style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground, fontWeight: FontWeight.w500)),
                const KsText(' · ', style: TextStyle(color: AppTheme.mutedForeground)),
                KsText(household.name, style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
                const SizedBox(width: 2),
                VerifiedBadge(verified: household.aadhaarVerified),
              ]),
            ])),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              WageTag(amount: job.budget),
              if (job.urgent) ...[const SizedBox(height: 4), const UrgentBadge()],
            ]),
          ]),

          if (job.description != null && job.description!.isNotEmpty) ...[
            const SizedBox(height: 10),
            KsText(job.description!, maxLines: 2, overflow: TextOverflow.ellipsis,
                style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground, height: 1.5)),
          ],

          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Wrap(spacing: 12, runSpacing: 6, children: [
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.calendar_today, size: 13, color: AppTheme.mutedForeground),
              const SizedBox(width: 4),
              KsText(_dateLabel(job.jobDate), style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground, fontWeight: FontWeight.w500)),
            ]),
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.access_time, size: 13, color: AppTheme.mutedForeground),
              const SizedBox(width: 4),
              KsText('${job.startTime} · ${job.durationHours}h', style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground, fontWeight: FontWeight.w500)),
            ]),
            DistanceChip(km: widget.feedJob.distanceKm),
            Row(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.people_outline, size: 13, color: AppTheme.mutedForeground),
              const SizedBox(width: 4),
              KsText('${widget.feedJob.interestCount}', style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground, fontWeight: FontWeight.w500)),
            ]),
          ]),

          // Expand form
          if (_expanded && _interest == null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: AppTheme.muted.withOpacity(0.6), borderRadius: BorderRadius.circular(12)),
              child: Column(children: [
                TextField(
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(text: '$_quote'),
                  onChanged: (v) => setState(() { _quote = int.tryParse(v) ?? _quote; }),
                  decoration: const InputDecoration(labelText: 'Your quote', prefixText: '₹', contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                ),
                const SizedBox(height: 8),
                TextField(
                  maxLines: 2,
                  onChanged: (v) => setState(() { _note = v; }),
                  decoration: const InputDecoration(hintText: 'I have done this work for 5 years.', labelText: 'Message (optional)', contentPadding: EdgeInsets.all(12)),
                ),
              ]),
            ),
          ],

          const SizedBox(height: 12),
          if (_interest == 'interested') Row(children: [
            Expanded(child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const Icon(Icons.check, size: 16, color: AppTheme.success),
                const SizedBox(width: 6),
                KsText('Interest sent', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700, color: AppTheme.success)),
              ]),
            )),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.primary, size: 20),
              onPressed: () {
                Navigator.of(context).pushNamed('/chat', arguments: {
                  'jobId': job.id,
                  'otherUserId': household.id,
                  'otherUserName': household.name,
                  'jobTitle': job.title,
                });
              },
            ),
            const SizedBox(width: 4),
            TextButton(onPressed: _loading ? null : _pull, child: KsText('Undo', style: GoogleFonts.notoSans(color: AppTheme.mutedForeground, fontWeight: FontWeight.w600))),
          ])
          else if (_expanded) Row(children: [
            Expanded(child: SizedBox(height: 44, child: ElevatedButton(
              onPressed: _loading ? null : _apply,
              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const KsText('Send interest'),
            ))),
            const SizedBox(width: 8),
            TextButton(onPressed: () => setState(() { _expanded = false; }), child: const KsText('Cancel')),
          ])
          else SizedBox(width: double.infinity, height: 44, child: ElevatedButton(
            onPressed: () => setState(() { _expanded = true; }),
            style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const KsText("I'm interested"),
          )),
        ],
      ),
    );
  }
}
