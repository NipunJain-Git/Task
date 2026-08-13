// Home shell — bottom nav + routing for worker and household
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
import '../shared/inbox_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  static const _tutorialSeenKey = 'home_tutorial_seen';
  final _notificationKey = GlobalKey();
  final _homeKey = GlobalKey();
  final _discoverKey = GlobalKey();
  final _actionKey = GlobalKey();
  final _mapKey = GlobalKey();
  final _profileKey = GlobalKey();
  bool _showTutorial = false;
  bool _canPop = false;

  @override
  void initState() {
    super.initState();
    _loadTutorial();
  }

  Future<void> _loadTutorial() async {
    // MOCK: Always show tutorial for demo purposes
    if (!mounted) return;
    setState(() => _showTutorial = true);
  }

  Future<void> _finishTutorial() async {
    setState(() => _showTutorial = false);
    // Removed shared preferences set to ensure it shows next time as well
  }

  Future<void> _handleBack() async {
    if (context.read<AppProvider>().goToPreviousTab()) return;

    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Exit KaamSetu?'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    if (shouldExit == true && mounted) {
      setState(() => _canPop = true);
      Navigator.of(context).pop();
    }
  }

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
      _TabItem(label: t('wallet'), icon: Icons.account_balance_wallet_outlined, activeIcon: Icons.account_balance_wallet),
      _TabItem(label: t('map'), icon: Icons.map_outlined, activeIcon: Icons.map),
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
      const WalletScreen(),
      const MapScreen(),
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

    final tabKeys = [_homeKey, _discoverKey, _actionKey, _mapKey, _profileKey];

    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, _) async {
        if (!didPop) await _handleBack();
      },
      child: Stack(
        children: [
          Scaffold(
            extendBody: true,
            appBar: AppBar(
              centerTitle: false,
              titleSpacing: 16,
              title: const KSAppBar(),
              actions: [
                IconButton(
                  icon: const Icon(Icons.chat_bubble_outline),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const InboxScreen())),
                ),
                _NotifButton(
                  key: _notificationKey,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NotificationsScreen()))
                ),
                const SizedBox(width: 8),
              ],
            ),
            body: IndexedStack(index: provider.currentTab, children: screens),
            floatingActionButton: FloatingActionButton(
              onPressed: () => Navigator.of(context).pushNamed('/chatbot'),
              backgroundColor: AppTheme.primary,
              child: const Icon(Icons.support_agent, color: Colors.white),
            ),
            bottomNavigationBar: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.85),
                    border: const Border(top: BorderSide(color: AppTheme.border)),
                  ),
                  child: BottomNavigationBar(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
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
                              key: tabKeys[e.key],
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
                        icon: Icon(
                          key: tabKeys[e.key],
                          provider.currentTab == e.key ? item.activeIcon : item.icon, 
                          size: 22
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          if (_showTutorial)
            _HomeTutorial(
              targets: [
                _TutorialTarget(
                  key: _notificationKey,
                  title: 'Stay updated',
                  message: 'Tap here to see job and account updates.',
                ),
                _TutorialTarget(
                  key: _homeKey,
                  title: 'Your home',
                  message: 'Come back here for your daily overview.',
                ),
                _TutorialTarget(
                  key: _discoverKey,
                  title: isWorker ? 'Find work' : 'Find workers',
                  message: isWorker
                      ? 'Browse nearby jobs and let households know you are interested.'
                      : 'Browse available workers near you.',
                ),
                _TutorialTarget(
                  key: _actionKey,
                  title: isWorker ? 'Your wallet' : 'Post a job',
                  message: isWorker
                      ? 'Check your earnings and manage payments here.'
                      : 'Create a job request in just a few steps.',
                ),
                _TutorialTarget(
                  key: _mapKey,
                  title: 'Explore the map',
                  message: 'See local work and people in your area.',
                ),
                _TutorialTarget(
                  key: _profileKey,
                  title: 'Your profile',
                  message: 'Keep your details and availability up to date.',
                ),
              ],
              onFinish: _finishTutorial,
            ),
        ],
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
  const _NotifButton({super.key, required this.onTap});

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

class _TutorialTarget {
  final GlobalKey key;
  final String title;
  final String message;

  const _TutorialTarget({
    required this.key,
    required this.title,
    required this.message,
  });
}

class _HomeTutorial extends StatefulWidget {
  final List<_TutorialTarget> targets;
  final VoidCallback onFinish;

  const _HomeTutorial({required this.targets, required this.onFinish});

  @override
  State<_HomeTutorial> createState() => _HomeTutorialState();
}

class _HomeTutorialState extends State<_HomeTutorial> {
  int _step = 0;

  void _next() {
    if (_step == widget.targets.length - 1) {
      widget.onFinish();
    } else {
      setState(() => _step++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final target = widget.targets[_step];
    final rootBox = context.findRenderObject() as RenderBox?;
    final targetBox =
        target.key.currentContext?.findRenderObject() as RenderBox?;
    final rect = rootBox != null && targetBox != null && targetBox.hasSize
        ? targetBox.localToGlobal(Offset.zero, ancestor: rootBox) &
              targetBox.size
        : null;

    if (rect == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() {});
      });
      return const SizedBox.expand();
    }

    final size = MediaQuery.sizeOf(context);
    final isBottomTarget = rect.center.dy > size.height / 2;
    final cardWidth = (size.width - 40).clamp(0.0, 360.0).toDouble();
    final cardTop = isBottomTarget
        ? (rect.top - 178).clamp(88.0, size.height - 190.0).toDouble()
        : (rect.bottom + 36).clamp(88.0, size.height - 190.0).toDouble();
    final cardLeft = (rect.center.dx - cardWidth / 2)
        .clamp(20.0, size.width - cardWidth - 20.0)
        .toDouble();
    final arrowTop = isBottomTarget ? rect.top - 36 : rect.bottom + 6;
    final arrowLeft = (rect.center.dx - 14)
        .clamp(8.0, size.width - 36.0)
        .toDouble();

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: _SpotlightPainter(rect.inflate(12))),
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {},
            ),
          ),
          Positioned(
            left: arrowLeft,
            top: arrowTop,
            child: Icon(
              isBottomTarget
                  ? Icons.arrow_downward_rounded
                  : Icons.arrow_upward_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          Positioned(
            left: cardLeft,
            top: cardTop,
            width: cardWidth,
            child: _TutorialCard(
              step: _step + 1,
              total: widget.targets.length,
              title: target.title,
              message: target.message,
              isLast: _step == widget.targets.length - 1,
              onNext: _next,
              onSkip: widget.onFinish,
            ),
          ),
        ],
      ),
    );
  }
}

class _TutorialCard extends StatelessWidget {
  final int step;
  final int total;
  final String title;
  final String message;
  final bool isLast;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const _TutorialCard({
    required this.step,
    required this.total,
    required this.title,
    required this.message,
    required this.isLast,
    required this.onNext,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 12),
      decoration: BoxDecoration(
        color: AppTheme.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 18)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$step of $total',
            style: GoogleFonts.notoSans(
              color: AppTheme.mutedForeground,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.notoSans(
              color: AppTheme.foreground,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            message,
            style: GoogleFonts.notoSans(
              color: AppTheme.secondaryForeground,
              fontSize: 14,
              height: 1.35,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: onSkip, child: const Text('Skip')),
              const SizedBox(width: 4),
              FilledButton(
                onPressed: onNext,
                child: Text(isLast ? 'Done' : 'Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  final Rect target;

  const _SpotlightPainter(this.target);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = Colors.black.withValues(alpha: 0.72),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(target, const Radius.circular(20)),
      Paint()..blendMode = BlendMode.clear,
    );
    canvas.restore();
    canvas.drawRRect(
      RRect.fromRectAndRadius(target, const Radius.circular(20)),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) =>
      oldDelegate.target != target;
}
