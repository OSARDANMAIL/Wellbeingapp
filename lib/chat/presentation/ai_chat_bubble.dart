import 'package:flutter/material.dart';
import 'package:well_being_app/model/ai_messages.dart';

class AiChatBubble extends StatelessWidget {
  final AiMessages AiMessage;

  const AiChatBubble({
    super.key,
    required this.AiMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          AiMessage.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: AiMessage.isUser ? Colors.green : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          AiMessage.content,
          style:
              TextStyle(color: AiMessage.isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
