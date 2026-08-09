import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kaamsetu_app/l10n/app_localizations.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/wallet_provider.dart';

class WalletDashboardScreen extends ConsumerWidget {
  const WalletDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final walletState = ref.watch(walletNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wallet),
        centerTitle: true,
      ),
      body: walletState.when(
        initial: () => const Center(child: CircularProgressIndicator()),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err) => Center(child: Text(err, style: const TextStyle(color: Colors.red))),
        loaded: (wallet, hasPin) {
          if (!hasPin) {
            return _SetupPinPrompt();
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(walletNotifierProvider.notifier).fetchWallet(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _BalanceCard(balance: wallet.balance),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionBtn(
                        icon: Icons.add,
                        label: l10n.addMoney,
                        onTap: () => _showAddMoneyDialog(context, ref),
                      ),
                      _ActionBtn(
                        icon: Icons.family_restroom,
                        label: l10n.sendToFamily,
                        onTap: () => _showSendToFamilyDialog(context, ref, wallet.balance),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Transactions',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  if (wallet.transactions.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No transactions yet'),
                    ))
                  else
                    ...wallet.transactions.map((tx) {
                      final isCredit = tx.type == 'CREDIT';
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isCredit ? Colors.green.withAlpha((0.1 * 255).toInt()) : Colors.red.withAlpha((0.1 * 255).toInt()),
                            child: Icon(
                              isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                              color: isCredit ? Colors.green : Colors.red,
                            ),
                          ),
                          title: Text(tx.description ?? (isCredit ? 'Credit' : 'Debit')),
                          subtitle: Text(tx.receiptNumber),
                          trailing: Text(
                            '${isCredit ? '+' : '-'}₹${tx.amount.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: isCredit ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      );
                    }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddMoneyDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.addMoney),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Amount',
            prefixText: '₹ ',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount > 0) {
                ref.read(walletNotifierProvider.notifier).addMoney(amount);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Add via UPI'),
          ),
        ],
      ),
    );
  }

  void _showSendToFamilyDialog(BuildContext context, WidgetRef ref, double balance) {
    final l10n = AppLocalizations.of(context)!;
    final amountController = TextEditingController();
    final pinController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.sendToFamily),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Amount (Max ₹${balance.toStringAsFixed(0)})',
                prefixText: '₹ ',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pinController,
              keyboardType: TextInputType.number,
              obscureText: true,
              maxLength: 4,
              decoration: const InputDecoration(
                hintText: '4-Digit PIN',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(amountController.text);
              final pin = pinController.text;
              if (amount != null && amount > 0 && amount <= balance && pin.length == 4) {
                ref.read(walletNotifierProvider.notifier).transferToFamily(amount, pin);
                Navigator.pop(ctx);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Invalid amount or PIN')),
                );
              }
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

class _SetupPinPrompt extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 64, color: AppTheme.primaryGreen),
            const SizedBox(height: 24),
            Text(
              'Secure Your Wallet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Set up a 4-digit PIN to authorize transfers and payouts.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.push('/setup-pin'),
              child: Text(l10n.setupPin),
            )
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  const _BalanceCard({required this.balance});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryGreen, Color(0xFF1E824C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withAlpha((0.3 * 255).toInt()),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.balance,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            '₹${balance.toStringAsFixed(2)}',
            style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen.withAlpha((0.1 * 255).toInt()),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primaryGreen, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
