// Post job screen — mirrors components/kaam/post-job-form.tsx
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/domain.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';

class PostJobScreen extends StatefulWidget {
  const PostJobScreen({super.key});

  @override
  State<PostJobScreen> createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  String _category = 'cleaning';
  int _budget = 500;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  String _startTime = '09:00';
  int _durationHours = 4;
  bool _urgent = false;
  bool _loading = false;
  String _notice = '';

  bool get _canPost => _titleCtrl.text.trim().length >= 3;

  Future<void> _submit() async {
    if (!_canPost) return;
    setState(() { _loading = true; _notice = ''; });
    final err = await context.read<AppProvider>().postJob(
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim().isNotEmpty ? _descCtrl.text.trim() : null,
      category: _category,
      budget: _budget,
      jobDate: '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}',
      startTime: _startTime,
      durationHours: _durationHours,
      urgent: _urgent,
    );
    if (mounted) {
      setState(() { _loading = false; });
      if (err == null) {
        setState(() { _notice = 'Job posted! Workers nearby have been notified.'; });
        _titleCtrl.clear();
        _descCtrl.clear();
      } else {
        setState(() { _notice = err; });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        KsText('Post a one-day job', style: GoogleFonts.notoSans(fontSize: 22, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        KsText('Workers nearby will be notified immediately.', style: GoogleFonts.notoSans(fontSize: 13, color: AppTheme.mutedForeground)),
        const SizedBox(height: 24),

        // Job title
        TextField(
          controller: _titleCtrl,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(labelText: 'Job title *', hintText: 'e.g. Deep clean 2BHK'),
        ),
        const SizedBox(height: 12),

        // Description
        TextField(
          controller: _descCtrl,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Description (optional)', hintText: 'Tools provided, 2nd floor, etc.'),
        ),
        const SizedBox(height: 20),

        // Category
        KsText('Category', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true, crossAxisCount: 3, childAspectRatio: 2, mainAxisSpacing: 8, crossAxisSpacing: 8,
          physics: const NeverScrollableScrollPhysics(),
          children: kSkills.map((s) => GestureDetector(
            onTap: () => setState(() { _category = s.key; }),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              decoration: BoxDecoration(
                color: _category == s.key ? AppTheme.primary.withOpacity(0.1) : AppTheme.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: _category == s.key ? AppTheme.primary : AppTheme.border, width: 2),
              ),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                KsText(s.emoji, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Flexible(child: KsText(s.label, style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w600, color: _category == s.key ? AppTheme.primary : AppTheme.foreground), overflow: TextOverflow.ellipsis)),
              ]),
            ),
          )).toList(),
        ),
        const SizedBox(height: 20),

        // Budget
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                KsText('Budget', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600)),
                KsText('₹$_budget', style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.primary)),
              ]),
              Slider(value: _budget.toDouble(), min: 100, max: 5000, divisions: 49, activeColor: AppTheme.primary,
                  onChanged: (v) => setState(() { _budget = (v / 100).round() * 100; })),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                KsText('₹100', style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.mutedForeground)),
                KsText('₹5,000', style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.mutedForeground)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Date
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            KsText('Job date', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: () async {
                final d = await showDatePicker(context: context, initialDate: _date, firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 60)));
                if (d != null) setState(() { _date = d; });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border, width: 2)),
                child: Row(children: [
                  const Icon(Icons.calendar_today, size: 16, color: AppTheme.mutedForeground),
                  const SizedBox(width: 8),
                  KsText('${_date.day}/${_date.month}/${_date.year}', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w600)),
                ]),
              ),
            ),
          ])),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            KsText('Duration', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            DropdownButtonFormField<int>(
              value: _durationHours,
              onChanged: (v) => setState(() { _durationHours = v!; }),
              items: [1, 2, 3, 4, 5, 6, 7, 8].map((h) => DropdownMenuItem(value: h, child: KsText('$h hr${h > 1 ? 's' : ''}'))).toList(),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppTheme.border, width: 2)),
              ),
            ),
          ])),
        ]),
        const SizedBox(height: 16),

        // Urgent toggle
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _urgent ? AppTheme.destructive.withOpacity(0.06) : AppTheme.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _urgent ? AppTheme.destructive.withOpacity(0.4) : AppTheme.border),
          ),
          child: Row(children: [
            const Icon(Icons.local_fire_department, color: AppTheme.destructive, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              KsText('Mark as urgent', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
              KsText('Workers are notified first, boosts visibility', style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
            ])),
            Switch(value: _urgent, activeColor: AppTheme.destructive, onChanged: (v) => setState(() { _urgent = v; })),
          ]),
        ),

        if (_notice.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(12)),
            child: KsText(_notice, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.secondaryForeground)),
          ),
        ],

        const SizedBox(height: 24),
        KsPrimaryButton(
          label: 'Post job',
          onTap: _canPost ? _submit : null,
          isLoading: _loading,
          icon: const Icon(Icons.send, size: 18, color: Colors.white),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
