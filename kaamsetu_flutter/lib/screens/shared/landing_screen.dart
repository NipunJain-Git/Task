// Landing page — mirrors app/page.tsx
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../widgets/atoms.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        KaamSetuLogo(),
                        SizedBox(height: 2),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: KsText('Open app', style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
                    ),
                  ],
                ),
              ),

              // Hero section
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.accent.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.accent, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        KsText('Built for one-day work', style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.accentForeground)),
                      ]),
                    ),
                    const SizedBox(height: 16),
                    KsText(
                      "A bridge between a day's work and the household next door.",
                      style: GoogleFonts.notoSans(fontSize: 28, fontWeight: FontWeight.w800, height: 1.25, color: AppTheme.foreground),
                    ),
                    const SizedBox(height: 12),
                    KsText(
                      'KaamSetu connects daily-wage workers with nearby households for one-day jobs — real profiles, real ratings, real payouts.',
                      style: GoogleFonts.notoSans(fontSize: 14, color: AppTheme.mutedForeground, height: 1.6),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity, height: 52,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/login', arguments: {'role': 'worker'}),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: const KsText('I need work'),
                        style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity, height: 52,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pushNamed(context, '/login', arguments: {'role': 'household'}),
                        style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                        child: const KsText('I need to hire'),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats strip
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppTheme.card,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        children: [
                          for (final stat in [
                            {'k': '5', 'v': 'languages'},
                            {'k': '2-way', 'v': 'ratings'},
                            {'k': '0', 'v': 'platform fee'},
                          ]) ...[
                            Expanded(
                              child: Column(
                                children: [
                                  KsText(stat['k']!, style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.primary)),
                                  KsText(stat['v']!, style: GoogleFonts.notoSans(fontSize: 11, fontWeight: FontWeight.w500, color: AppTheme.mutedForeground)),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Mock phone card
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.card,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.foreground.withOpacity(0.8), width: 4),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 24, offset: const Offset(0, 8))],
                  ),
                  child: Column(
                    children: [
                      Row(children: [
                        const KaamSetuLogo(size: 22),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: AppTheme.success.withOpacity(0.1), borderRadius: BorderRadius.circular(999)),
                          child: Row(children: [
                            Container(width: 6, height: 6, decoration: const BoxDecoration(color: AppTheme.success, shape: BoxShape.circle)),
                            const SizedBox(width: 4),
                            KsText('Available', style: GoogleFonts.notoSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.success)),
                          ]),
                        ),
                      ]),
                      const SizedBox(height: 12),
                      for (final j in [
                        {'t': 'Deep clean 2BHK', 'p': '₹900', 'd': '600 m', 'u': true},
                        {'t': 'Paint two rooms', 'p': '₹1,600', 'd': '1.2 km', 'u': false},
                        {'t': 'Fix leaking tap', 'p': '₹450', 'd': '2.4 km', 'u': true},
                      ]) ...[
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(
                            children: [
                              Row(children: [
                                Expanded(child: KsText(j['t'] as String, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w700))),
                                KsText(j['p'] as String, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w800, color: AppTheme.primary)),
                              ]),
                              const SizedBox(height: 4),
                              Row(children: [
                                KsText(j['d'] as String, style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.mutedForeground)),
                                const SizedBox(width: 8),
                                if (j['u'] == true) Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(color: AppTheme.destructive.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                                  child: KsText('Urgent', style: GoogleFonts.notoSans(fontSize: 10, fontWeight: FontWeight.w700, color: AppTheme.destructive)),
                                ),
                                const Spacer(),
                                const Icon(Icons.thumb_up, size: 11, color: AppTheme.primary),
                                const SizedBox(width: 3),
                                KsText('96%', style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                              ]),
                            ],
                          ),
                        ),
                      ],
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(12)),
                        child: KsText('3 jobs within 3 km · Pune', textAlign: TextAlign.center,
                            style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ],
                  ),
                ),
              ),

              // Features section
              Container(
                color: AppTheme.card,
                padding: const EdgeInsets.fromLTRB(20, 32, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    KsText('Everything a one-day job needs.', style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 20),
                    for (final f in [
                      {'icon': Icons.radar, 'title': 'Hyperlocal matching', 'body': 'Nearest right job first — scored on skills, walking distance, pay and urgency.'},
                      {'icon': Icons.location_on, 'title': 'Live availability map', 'body': 'Workers flip on Available Now and appear live inside your geofence radius.'},
                      {'icon': Icons.verified_user, 'title': 'Aadhaar-backed trust', 'body': 'Verified badges, thumbs history and work streaks build one readable trust score.'},
                      {'icon': Icons.account_balance_wallet, 'title': 'Wallet with PIN', 'body': 'Completing a job releases the wage straight into the worker\'s wallet.'},
                      {'icon': Icons.chat_bubble_outline, 'title': 'Chat & KaamBot', 'body': 'Per-job chat, instant bot answers, and a customer care ticket line.'},
                      {'icon': Icons.shield_outlined, 'title': 'Family safety net', 'body': 'One tap sends your family contact a live job location.'},
                    ]) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.background,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppTheme.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 36, height: 36,
                              decoration: BoxDecoration(color: AppTheme.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: Icon(f['icon'] as IconData, color: AppTheme.primary, size: 18),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              KsText(f['title'] as String, style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
                              const SizedBox(height: 2),
                              KsText(f['body'] as String, style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground, height: 1.5)),
                            ])),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // CTA footer
              Container(
                width: double.infinity,
                color: AppTheme.primary,
                padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                child: Column(
                  children: [
                    KsText('Work is local. Hiring should be too.', style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
                    const SizedBox(height: 8),
                    KsText('Sign in with any 10-digit number — the demo OTP is 123456.', style: GoogleFonts.notoSans(fontSize: 13, color: Colors.white.withOpacity(0.8))),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity, height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pushNamed(context, '/login'),
                        icon: const Icon(Icons.arrow_forward, size: 18),
                        label: const KsText('Get started'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, foregroundColor: AppTheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer
              Padding(
                padding: const EdgeInsets.all(20),
                child: KsText('KaamSetu — hyperlocal daily-wage job connect. Built as a fully functional product demo.',
                    style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
