import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';
import '../../widgets/atoms.dart';

class InboxScreen extends StatefulWidget {
  const InboxScreen({super.key});

  @override
  State<InboxScreen> createState() => _InboxScreenState();
}

class _InboxScreenState extends State<InboxScreen> {
  bool _loading = true;
  List<dynamic> _chats = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final list = await context.read<AppProvider>().getInbox();
    if (mounted) setState(() { _chats = list; _loading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inbox'),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        color: AppTheme.primary,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SectionTitle(
              title: 'Your Chats',
              action: KsText('${_chats.length} active', style: GoogleFonts.notoSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.mutedForeground)),
            ),
            const SizedBox(height: 8),
            if (_loading) 
              ...List.generate(3, (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    const ShimmerBox(width: 48, height: 48, borderRadius: BorderRadius.all(Radius.circular(24))),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const ShimmerBox(width: 120, height: 16),
                          const SizedBox(height: 8),
                          const ShimmerBox(width: double.infinity, height: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
            else if (_chats.isEmpty)
              const EmptyState(icon: Icons.chat_bubble_outline, title: 'No messages yet', body: 'When you connect with someone for a job, your chats will appear here.')
            else
              ..._chats.map((chat) {
                final isUnread = !chat['isRead'] && chat['senderId'] != context.read<AppProvider>().user?.id;
                
                return Dismissible(
                  key: Key(chat['jobId'] + chat['otherUserId']),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(color: AppTheme.destructive, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.archive, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    setState(() { _chats.remove(chat); });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: KsText('Chat archived'), behavior: SnackBarBehavior.floating));
                  },
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushNamed('/chat', arguments: {
                        'jobId': chat['jobId'],
                        'otherUserId': chat['otherUserId'],
                        'otherUserName': chat['otherUserName'],
                        'jobTitle': chat['jobTitle'],
                      }).then((_) => _load()); // refresh when coming back
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppTheme.card, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppTheme.border)),
                      child: Row(children: [
                        Container(
                          width: 48, height: 48,
                          decoration: const BoxDecoration(color: AppTheme.secondary, shape: BoxShape.circle),
                          child: chat['otherUserPhoto'] != null 
                            ? ClipOval(child: Image.network(chat['otherUserPhoto'], fit: BoxFit.cover))
                            : Center(child: KsText(chat['otherUserName'][0], style: GoogleFonts.notoSans(fontSize: 20, fontWeight: FontWeight.w800, color: AppTheme.primary))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(child: KsText(chat['otherUserName'], style: GoogleFonts.notoSans(fontSize: 15, fontWeight: isUnread ? FontWeight.w800 : FontWeight.w700), overflow: TextOverflow.ellipsis)),
                              KsText(chat['jobTitle'], style: GoogleFonts.notoSans(fontSize: 11, color: AppTheme.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          KsText(
                            chat['lastMessage'], 
                            maxLines: 1, 
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.notoSans(
                              fontSize: 13, 
                              color: isUnread ? Theme.of(context).colorScheme.onSurface : AppTheme.mutedForeground,
                              fontWeight: isUnread ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ])),
                        if (isUnread) ...[
                          const SizedBox(width: 8),
                          Container(width: 10, height: 10, decoration: const BoxDecoration(color: AppTheme.primary, shape: BoxShape.circle)),
                        ],
                      ]),
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
