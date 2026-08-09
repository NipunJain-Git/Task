// Home shell — bottom nav + routing for worker and household
import 'package:flutter/material.dart';
import '../../widgets/atoms.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../providers/app_provider.dart';
import '../worker/worker_home_screen.dart';
import '../worker/jobs_browser_screen.dart';
import '../worker/wallet_screen.dart';
import '../shared/profile_screen.dart';
import '../shared/map_screen.dart';
import '../shared/notifications_screen.dart';
import '../household/household_home_screen.dart';
import '../household/workers_browser_screen.dart';
import '../household/post_job_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final user = provider.user!;
    final lang = provider.lang;
    String t(String key) => tr(lang, key);
    final isWorker = user.role == 'worker';

    final workerTabs = [
      _TabItem(label: t('home'), icon: Icons.home_outlined, activeIcon: Icons.home),
      _TabItem(label: t('jobs'), icon: Icons.work_outline, activeIcon: Icons.work),
      _TabItem(label: t('map'), icon: Icons.map_outlined, activeIcon: Icons.map),
      _TabItem(label: t('wallet'), icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet),
      _TabItem(label: t('profile'), icon: Icons.person_outline, activeIcon: Icons.person),
    ];

    final householdTabs = [
      _TabItem(label: t('home'), icon: Icons.home_outlined, activeIcon: Icons.home),
      _TabItem(label: t('workers'), icon: Icons.people_outline, activeIcon: Icons.people),
      _TabItem(label: t('post'), icon: Icons.add_circle_outline, activeIcon: Icons.add_circle, isPost: true),
      _TabItem(label: t('map'), icon: Icons.map_outlined, activeIcon: Icons.map),
      _TabItem(label: t('profile'), icon: Icons.person_outline, activeIcon: Icons.person),
    ];

    final tabs = isWorker ? workerTabs : householdTabs;

    final workerScreens = [
      const WorkerHomeScreen(),
      const JobsBrowserScreen(),
      const MapScreen(),
      const WalletScreen(),
      const ProfileScreen(),
    ];

    final householdScreens = [
      const HouseholdHomeScreen(),
      const WorkersBrowserScreen(),
      const PostJobScreen(),
      const MapScreen(),
      const ProfileScreen(),
    ];

    final screens = isWorker ? workerScreens : householdScreens;

    return Scaffold(
      appBar: AppBar(
        title: const KSAppBar(),
        actions: [
          _NotifButton(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))),
          const SizedBox(width: 8),
        ],
      ),
      body: IndexedStack(index: provider.currentTab, children: screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: BottomNavigationBar(
          currentIndex: provider.currentTab,
          onTap: (i) => provider.setTab(i),
          items: tabs.asMap().entries.map((e) {
            final item = e.value;
            if (item.isPost) {
              return BottomNavigationBarItem(
                label: item.label,
                icon: Transform.translate(
                  offset: const Offset(0, -6),
                  child: Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppTheme.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6))],
                    ),
                    child: Icon(item.icon, color: Colors.white, size: 24),
                  ),
                ),
              );
            }
            return BottomNavigationBarItem(
              label: item.label,
              icon: Icon(provider.currentTab == e.key ? item.activeIcon : item.icon, size: 22),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final bool isPost;
  const _TabItem({required this.label, required this.icon, required this.activeIcon, this.isPost = false});
}

class KSAppBar extends StatelessWidget {
  const KSAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const KaamSetuLogo(size: 26);
  }
}

// ignore: must_be_immutable
class KaamSetuLogo extends StatelessWidget {
  final double size;
  const KaamSetuLogo({super.key, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size, height: size,
          decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(size * 0.3)),
          child: Center(child: KsText('K', style: GoogleFonts.notoSans(color: Colors.white, fontSize: size * 0.55, fontWeight: FontWeight.w900))),
        ),
        const SizedBox(width: 8),
        KsText('KaamSetu', style: GoogleFonts.notoSans(color: Theme.of(context).colorScheme.onSurface, fontSize: size * 0.58, fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _NotifButton extends StatelessWidget {
  final VoidCallback onTap;
  const _NotifButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final count = context.watch<AppProvider>().unreadCount;
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          const Padding(padding: EdgeInsets.all(8), child: Icon(Icons.notifications_outlined)),
          if (count > 0)
            Positioned(
              right: 4, top: 4,
              child: Container(
                width: 16, height: 16,
                decoration: const BoxDecoration(color: AppTheme.destructive, shape: BoxShape.circle),
                child: KsText('$count', textAlign: TextAlign.center,
                    style: GoogleFonts.notoSans(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
              ),
            ),
        ],
      ),
    );
  }
}
