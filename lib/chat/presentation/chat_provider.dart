import 'package:flutter/material.dart';
import 'package:well_being_app/chat/data/claude_api_service.dart';
import 'package:well_being_app/model/ai_messages.dart';

class ChatProvider with ChangeNotifier {
  // Claude API service
  final _apiService = ClaudeApiService(
      apiKey:
          "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");

  // Messages and Loading
  final List<AiMessages> _messages = [];
  bool _isLoading = false;

  // Getter
  List<AiMessages> get messages => _messages;
  bool get isLoading => _isLoading;

  // Send message
  Future<void> sendMessage(String content) async {
    // Prevent empty sends
    if (content.trim().isEmpty) return;

    // Create user message
    final userMessage = AiMessages(
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add user message to chat
    _messages.add(userMessage);

    // Notify listeners to update UI
    notifyListeners();

    // Send Message and Recieve response
    try {
      final response = await _apiService.sendMessage(content);

      final responseMessage = AiMessages(
          content: response, isUser: false, timestamp: DateTime.now());

      _messages.add(responseMessage);
    }
    //error
    catch (e) {
      //error message
      final errorMessage = AiMessages(
        content: "Sorry, I encountered an issue.. $e",
        isUser: false,
        timestamp: DateTime.now(),
      );
      // add meessage to chat
      _messages.add(errorMessage);
    }

    // finished loading
    _isLoading = false;

    // update UI
    notifyListeners();
  }
}
