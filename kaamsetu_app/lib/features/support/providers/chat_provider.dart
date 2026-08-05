import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_client.dart';

final chatProvider = NotifierProvider<ChatNotifier, List<ChatMessage>>(() {
  return ChatNotifier();
});

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage(this.text, this.isUser);
}

class ChatNotifier extends Notifier<List<ChatMessage>> {
  late Dio _dio;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  List<ChatMessage> build() {
    _dio = ref.read(dioProvider);
    return [
      ChatMessage("Hi! I'm the KaamSetu AI Assistant. How can I help you today?", false),
    ];
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;
    
    // Add user message
    state = [...state, ChatMessage(text, true)];
    _isLoading = true;
    
    try {
      final response = await _dio.post<Map<String, dynamic>>('/support/chat', data: {'message': text});
      final reply = response.data?['reply'] as String? ?? "Sorry, I couldn't understand that.";
      
      state = [...state, ChatMessage(reply, false)];
    } catch (e) {
      state = [...state, ChatMessage("Sorry, I am having trouble connecting.", false)];
    } finally {
      _isLoading = false;
    }
  }
}
