// Household home screen
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../providers/app_provider.dart';
import '../../data/models.dart';
import '../../widgets/atoms.dart';
import 'package:flutter_animate/flutter_animate.dart';

void _showApplicants(BuildContext context, String jobId) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _ApplicantsSheet(jobId: jobId),
  );
}

class _ApplicantsSheet extends StatefulWidget {
  final String jobId;
  const _ApplicantsSheet({required this.jobId});
  @override
  State<_ApplicantsSheet> createState() => _ApplicantsSheetState();
}

class _ApplicantsSheetState extends State<_ApplicantsSheet> {
  bool _loading = true;
  List<dynamic> _applicants = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await context.read<AppProvider>().getApplicants(widget.jobId);
    if (mounted) setState(() { _applicants = list; _loading = false; });
  }

  Future<void> _assign(String workerId) async {
    setState(() => _loading = true);
    await context.read<AppProvider>().assignWorker(widget.jobId, workerId);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppTheme.background, borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          KsText('Applicants', style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w800)),
          IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        ]),
        const SizedBox(height: 16),
        if (_loading) const Expanded(child: Center(child: CircularProgressIndicator()))
        else if (_applicants.isEmpty) Expanded(child: Center(child: KsText('No applicants yet', style: GoogleFonts.notoSans(color: AppTheme.mutedForeground))))
        else Expanded(
          child: ListView.separated(
            itemCount: _applicants.length,
            separatorBuilder: (c, i) => const SizedBox(height: 12),
            itemBuilder: (c, i) {
              final w = _applicants[i]['worker'];
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                child: Row(children: [
                  Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: AppTheme.secondary, shape: BoxShape.circle),
                    child: Center(child: KsText(w['name'][0], style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.primary))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    KsText(w['name'], style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    KsText('Matched worker', style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground)),
                  ])),
                  ElevatedButton(
                    onPressed: () => _assign(w['id']),
                    style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    child: const KsText('Accept & Chat'),
                  ),
                ]),
              );
            },
          ),
        ),
      ]),
    );
  }
}

void _showRatingSheet(BuildContext context, Job job) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _RatingSheet(job: job),
  );
}

class _RatingSheet extends StatefulWidget {
  final Job job;
  const _RatingSheet({required this.job});
  @override
  State<_RatingSheet> createState() => _RatingSheetState();
}

class _RatingSheetState extends State<_RatingSheet> {
  bool _loading = false;

  Future<void> _submit(bool thumbsUp) async {
    setState(() => _loading = true);
    await context.read<AppProvider>().completeAndRateJob(widget.job.id, widget.job.assignedWorkerId ?? '', thumbsUp);
    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: KsText('Job marked as completed! ${thumbsUp ? '👍' : '👎'}', style: const TextStyle(color: Colors.white)),
          backgroundColor: AppTheme.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppTheme.background, borderRadius: const BorderRadius.vertical(top: Radius.circular(32))),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.1), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: AppTheme.success, size: 40),
            ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.easeOutBack),
            const SizedBox(height: 20),
            KsText('Job Completed!', style: GoogleFonts.notoSans(fontSize: 24, fontWeight: FontWeight.w900)).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
            const SizedBox(height: 8),
            KsText('How was ${widget.job.assignedWorkerName ?? 'the worker'}?', style: GoogleFonts.notoSans(fontSize: 16, color: AppTheme.mutedForeground)).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
            const SizedBox(height: 32),
            if (_loading) const CircularProgressIndicator()
            else Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RateButton(icon: Icons.thumb_down, label: 'Poor', color: AppTheme.destructive, onTap: () => _submit(false))
                    .animate().fadeIn(delay: 400.ms).slideX(begin: -0.5),
                const SizedBox(width: 24),
                _RateButton(icon: Icons.thumb_up, label: 'Great', color: AppTheme.success, onTap: () => _submit(true))
                    .animate().fadeIn(delay: 400.ms).slideX(begin: 0.5),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _RateButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _RateButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(color: AppTheme.card, shape: BoxShape.circle, border: Border.all(color: AppTheme.border), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))]),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 8),
          KsText(label, style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }
}

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
                Expanded(child: ElevatedButton.icon(
                  onPressed: () => provider.setTab(2),
                  icon: const Icon(Icons.add_circle_outline, size: 16),
                  label: const KsText('Post a job'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, foregroundColor: AppTheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )),
                const SizedBox(width: 8),
                Expanded(child: OutlinedButton.icon(
                  onPressed: () => provider.setTab(1),
                  icon: const Icon(Icons.people_outline, size: 16, color: Colors.white),
                  label: const KsText('Browse', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.white.withOpacity(0.5)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )),
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
            child: Column(
              children: [
                Row(children: [
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
                  if (job.status == 'assigned' && job.assignedWorkerId != null) ...[
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, color: AppTheme.primary, size: 20),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/chat', arguments: {
                          'jobId': job.id,
                          'otherUserId': job.assignedWorkerId!,
                          'otherUserName': job.assignedWorkerName ?? 'Worker',
                          'jobTitle': job.title,
                        });
                      },
                    ),
                    const SizedBox(width: 4),
                  ],
                  StatusPill(status: job.status),
                ]),
                if (job.status == 'open' && job.interestsCount > 0) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: ElevatedButton.icon(
                      onPressed: () => _showApplicants(context, job.id),
                      icon: const Icon(Icons.people, size: 16),
                      label: KsText('View ${job.interestsCount} Applicant${job.interestsCount > 1 ? 's' : ''}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primary.withOpacity(0.1),
                        foregroundColor: AppTheme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  )
                ] else if (job.status == 'assigned') ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 36,
                    child: OutlinedButton.icon(
                      onPressed: () => _showRatingSheet(context, job),
                      icon: const Icon(Icons.check_circle_outline, size: 16, color: AppTheme.success),
                      label: const KsText('Mark Completed', style: TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppTheme.success.withOpacity(0.5)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  )
                ]
              ],
            ),
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
