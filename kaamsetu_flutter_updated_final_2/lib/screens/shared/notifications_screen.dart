// Notifications screen — mirrors components/kaam/notifications-page.tsx
import 'package:flutter/material.dart';
import '../../widgets/atoms.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppProvider>().markNotificationsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifs = context.watch<AppProvider>().notifications;

    return Scaffold(
      appBar: AppBar(
        title: KsText(
          'Notifications',
          style: GoogleFonts.notoSans(
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: notifs.isEmpty
          ? Center(
              child: KsText(
                'No notifications yet',
                style: GoogleFonts.notoSans(
                  color: AppTheme.mutedForeground,
                  fontSize: 14,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifs.length,
              itemBuilder: (_, i) {
                final n = notifs[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: n.read
                        ? AppTheme.card
                        : AppTheme.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: n.read
                          ? AppTheme.border
                          : AppTheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.notifications_outlined,
                          size: 18,
                          color: AppTheme.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KsText(
                              n.title,
                              style: GoogleFonts.notoSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            KsText(
                              n.body,
                              style: GoogleFonts.notoSans(
                                fontSize: 13,
                                color: AppTheme.mutedForeground,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 6),
                            KsText(
                              _timeAgo(n.createdAt),
                              style: GoogleFonts.notoSans(
                                fontSize: 11,
                                color: AppTheme.mutedForeground,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (!n.read)
                        Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: const BoxDecoration(
                            color: AppTheme.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
