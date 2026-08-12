import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/api_client.dart';
import '../../core/theme.dart';
import '../../providers/app_provider.dart';

class ChatScreen extends StatefulWidget {
  final String jobId;
  final String otherUserId;
  final String otherUserName;
  final String jobTitle;

  const ChatScreen({
    super.key,
    required this.jobId,
    required this.otherUserId,
    required this.otherUserName,
    required this.jobTitle,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _textCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  List<Map<String, dynamic>> _messages = [];
  bool _loading = true;
  bool _sending = false;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _pollTimer = Timer.periodic(const Duration(seconds: 5), (_) => _loadMessages());
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final res = await apiClient.dio.get('/chat/${widget.jobId}');
      final msgs = (res.data['data'] as List? ?? []).cast<Map<String, dynamic>>();
      if (mounted) {
        setState(() {
          _messages = msgs;
          _loading = false;
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) setState(() { _loading = false; });
    }
  }

  Future<void> _sendMessage() async {
    final text = _textCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() { _sending = true; });
    _textCtrl.clear();
    try {
      await apiClient.dio.post('/chat/${widget.jobId}', data: {
        'receiverId': widget.otherUserId,
        'text': text,
      });
      await _loadMessages();
    } catch (e) {
      // ignore
    } finally {
      if (mounted) setState(() { _sending = false; });
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final myId = context.read<AppProvider>().user?.id ?? '';
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.card,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.otherUserName,
                style: GoogleFonts.notoSans(fontSize: 16, fontWeight: FontWeight.w700)),
            Text(widget.jobTitle,
                style: GoogleFonts.notoSans(fontSize: 12, color: AppTheme.mutedForeground)),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble_outline, size: 48, color: AppTheme.mutedForeground),
                            const SizedBox(height: 12),
                            Text('No messages yet. Say hello!',
                                style: GoogleFonts.notoSans(color: AppTheme.mutedForeground)),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollCtrl,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length,
                        itemBuilder: (context, i) {
                          final msg = _messages[i];
                          final isMine = msg['senderId'] == myId;
                          final time = DateTime.tryParse(msg['createdAt'] ?? '');
                          return Align(
                            alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.72,
                              ),
                              child: Column(
                                crossAxisAlignment: isMine
                                    ? CrossAxisAlignment.end
                                    : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isMine ? AppTheme.primary : AppTheme.card,
                                      borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(16),
                                        topRight: const Radius.circular(16),
                                        bottomLeft: Radius.circular(isMine ? 16 : 4),
                                        bottomRight: Radius.circular(isMine ? 4 : 16),
                                      ),
                                      border: isMine ? null : Border.all(color: AppTheme.border),
                                    ),
                                    child: Text(
                                      msg['text'] ?? '',
                                      style: GoogleFonts.notoSans(
                                        fontSize: 15,
                                        color: isMine ? Colors.white : AppTheme.foreground,
                                      ),
                                    ),
                                  ),
                                  if (time != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
                                      child: Text(
                                        '${time.hour.toString().padLeft(2,'0')}:${time.minute.toString().padLeft(2,'0')}',
                                        style: GoogleFonts.notoSans(
                                            fontSize: 11, color: AppTheme.mutedForeground),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            decoration: BoxDecoration(
              color: AppTheme.card,
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.background,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: TextField(
                        controller: _textCtrl,
                        maxLines: null,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          hintStyle: GoogleFonts.notoSans(
                              color: AppTheme.mutedForeground, fontSize: 14),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                        ),
                        style: GoogleFonts.notoSans(fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: _sending
                          ? const Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator(
                                  color: Colors.white, strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
