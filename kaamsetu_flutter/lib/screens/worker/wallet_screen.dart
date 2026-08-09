// Wallet screen — mirrors components/kaam/wallet-page.tsx
import 'package:flutter/material.dart';
import '../../widgets/atoms.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final _amountCtrl = TextEditingController(text: '500');
  final _pinCtrl = TextEditingController();
  bool _loading = false;
  String _notice = '';

  Future<void> _run(String kind) async {
    final amount = int.tryParse(_amountCtrl.text) ?? 0;
    final pin = _pinCtrl.text;
    if (amount <= 0) { setState(() { _notice = 'Enter a valid amount'; }); return; }
    setState(() { _loading = true; _notice = ''; });
    final provider = context.read<AppProvider>();
    final err = kind == 'topup' ? await provider.topUp(amount, pin) : await provider.withdraw(amount, pin);
    if (mounted) setState(() { _loading = false; _notice = err ?? 'Wallet updated!'; });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user!;
    final txs = provider.transactions;
    final hasPin = user.pin != null;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Header
        KsText('Money, made simple', style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary, letterSpacing: 1)),
        const SizedBox(height: 4),
        KsText('Your wallet', style: GoogleFonts.notoSans(fontSize: 24, fontWeight: FontWeight.w800)),
        const SizedBox(height: 20),

        // Balance card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(20)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.credit_card, color: Colors.white, size: 24),
              const SizedBox(height: 20),
              KsText('Available balance', style: GoogleFonts.notoSans(fontSize: 13, color: Colors.white.withOpacity(0.8))),
              const SizedBox(height: 4),
              KsText('₹${user.walletBalance}', style: GoogleFonts.notoSans(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
              const SizedBox(height: 16),
              Row(children: [
                KsText('Earned ₹${txs.where((t) => t.amount > 0).fold(0, (s, t) => s + t.amount)}',
                    style: GoogleFonts.notoSans(fontSize: 12, color: Colors.white.withOpacity(0.8))),
                const SizedBox(width: 20),
                KsText('Spent ₹${txs.where((t) => t.amount < 0).fold(0, (s, t) => s + t.amount.abs())}',
                    style: GoogleFonts.notoSans(fontSize: 12, color: Colors.white.withOpacity(0.8))),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // PIN & amount input
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppTheme.border)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                const Icon(Icons.lock_outline, size: 18, color: AppTheme.primary),
                const SizedBox(width: 8),
                KsText(hasPin ? 'PIN protected' : 'Set your PIN in Profile',
                    style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w700)),
              ]),
              const SizedBox(height: 12),
              TextField(
                controller: _pinCtrl,
                keyboardType: TextInputType.number,
                maxLength: 4,
                obscureText: true,
                decoration: const InputDecoration(hintText: '4-digit wallet PIN', counterText: '',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(hintText: 'Amount', prefixText: '₹',
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12)),
              ),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: SizedBox(height: 44, child: ElevatedButton.icon(
                  onPressed: (_loading || !hasPin) ? null : () => _run('topup'),
                  icon: const Icon(Icons.download, size: 16),
                  label: const KsText('Add money'),
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ))),
                const SizedBox(width: 8),
                Expanded(child: SizedBox(height: 44, child: OutlinedButton.icon(
                  onPressed: (_loading || !hasPin) ? null : () => _run('withdraw'),
                  icon: const Icon(Icons.upload, size: 16),
                  label: const KsText('Withdraw'),
                  style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ))),
              ]),
            ],
          ),
        ),

        if (_notice.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppTheme.secondary, borderRadius: BorderRadius.circular(10)),
            child: KsText(_notice, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.secondaryForeground)),
          ),
        ],
        const SizedBox(height: 24),

        // Transactions
        KsText('Recent activity', style: GoogleFonts.notoSans(fontSize: 17, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        if (txs.isEmpty)
          Center(child: KsText('No transactions yet', style: GoogleFonts.notoSans(color: AppTheme.mutedForeground, fontSize: 13)))
        else
          ...txs.map((tx) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
            child: Row(children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: tx.amount > 0 ? AppTheme.success.withOpacity(0.1) : AppTheme.destructive.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(tx.amount > 0 ? Icons.arrow_downward : Icons.arrow_upward,
                    size: 16, color: tx.amount > 0 ? AppTheme.success : AppTheme.destructive),
              ),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                KsText(tx.note, style: GoogleFonts.notoSans(fontSize: 13, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
                KsText('${tx.createdAt.day}/${tx.createdAt.month}/${tx.createdAt.year}',
                    style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.mutedForeground)),
              ])),
              KsText('${tx.amount > 0 ? '+' : '−'}₹${tx.amount.abs()}',
                  style: GoogleFonts.notoSans(fontSize: 14, fontWeight: FontWeight.w800,
                      color: tx.amount > 0 ? AppTheme.success : AppTheme.destructive)),
            ]),
          )),
      ],
    );
  }
}
