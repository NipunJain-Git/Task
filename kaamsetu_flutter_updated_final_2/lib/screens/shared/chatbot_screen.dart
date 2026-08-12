import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';
import '../../core/i18n.dart';
import '../../widgets/atoms.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [
    _ChatMessage(
      role: _ChatRole.bot,
      text: 'Hi! I am KaamBot. Ask me about the KaamSetu app or how to use it.',
    ),
  ];
  bool _isSending = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isSending) return;
    setState(() {
      _messages.add(_ChatMessage(role: _ChatRole.user, text: text.trim()));
      _isSending = true;
      _controller.clear();
    });
    await _scrollToBottom();

    await Future.delayed(const Duration(milliseconds: 500));
    final response = _createResponse(text.trim());
    setState(() {
      _messages.add(_ChatMessage(role: _ChatRole.bot, text: response));
      _isSending = false;
    });
    await _scrollToBottom();
  }

  Future<void> _scrollToBottom() async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  String _createResponse(String query) {
    final normalized = query.toLowerCase();
    if (normalized.contains('otp')) {
      return 'For this demo, the OTP is 123456. Enter it after sending to sign in.';
    }
    if (normalized.contains('work') || normalized.contains('jobs')) {
      return 'KaamSetu connects workers with nearby households for one-day jobs. Use the Jobs tab to browse work and set your availability in your Profile.';
    }
    if (normalized.contains('hire') || normalized.contains('household')) {
      return 'Households can post a one-day job from the Post tab. Workers nearby will see it and can express interest quickly.';
    }
    if (normalized.contains('wallet') ||
        normalized.contains('payment') ||
        normalized.contains('money')) {
      return 'Your wallet holds your earnings and top-ups. You can add money or withdraw from the Wallet tab, and pay workers from the app.';
    }
    if (normalized.contains('aadhaar') || normalized.contains('verify')) {
      return 'Verified users get more trust. Complete Aadhaar verification during onboarding or from Profile to improve your match visibility.';
    }
    if (normalized.contains('map')) {
      return 'The Map tab shows available workers and open jobs near you so you can discover nearby opportunities and people.';
    }
    if (normalized.contains('support') ||
        normalized.contains('help') ||
        normalized.contains('customer')) {
      return 'I can answer questions about using KaamSetu, signing in, posting jobs, and finding work. For direct support, use the app support option.';
    }
    if (normalized.contains('profile') ||
        normalized.contains('availability') ||
        normalized.contains('rating')) {
      return 'Your Profile shows your skills, availability, and trust score. Workers and households use it to decide who to hire.';
    }
    return 'I am KaamBot. Ask me about KaamSetu features, signing in, posting jobs, finding work, wallet use, or verification.';
  }

  @override
  Widget build(BuildContext context) {
    final lang = ModalRoute.of(context)?.settings.arguments as String? ?? 'en';
    String t(String key) => tr(lang, key);

    return Scaffold(
      appBar: AppBar(
        title: KsText(
          t('chatbot'),
          style: GoogleFonts.notoSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isUser = message.role == _ChatRole.user;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: isUser
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: isUser ? AppTheme.primary : AppTheme.card,
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(18),
                                topRight: const Radius.circular(18),
                                bottomLeft: Radius.circular(isUser ? 18 : 4),
                                bottomRight: Radius.circular(isUser ? 4 : 18),
                              ),
                            ),
                            child: KsText(
                              message.text,
                              style: GoogleFonts.notoSans(
                                fontSize: 14,
                                color: isUser
                                    ? Colors.white
                                    : AppTheme.foreground,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      decoration: InputDecoration(
                        hintText: t('chatbotHint'),
                        hintStyle: GoogleFonts.notoSans(
                          color: AppTheme.mutedForeground,
                        ),
                        filled: true,
                        fillColor: AppTheme.card,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _isSending
                          ? null
                          : () => _sendMessage(_controller.text),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: _isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _ChatRole { user, bot }

class _ChatMessage {
  final _ChatRole role;
  final String text;
  _ChatMessage({required this.role, required this.text});
}
