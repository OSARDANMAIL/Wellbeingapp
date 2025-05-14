import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:well_being_app/chat/presentation/ai_chat_bubble.dart';
import 'package:well_being_app/chat/presentation/chat_provider.dart';
import 'package:well_being_app/model/ai_messages.dart';

class AiChatPage extends StatefulWidget {
  const AiChatPage({super.key});

  @override
  State<AiChatPage> createState() => _AiChatPageState();
}

class _AiChatPageState extends State<AiChatPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // TOP SECTION: Chat Messages
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  // If chat is empty
                  if (chatProvider.messages.isEmpty) {
                    return const Center(child: Text("Start a convo"));
                  }

                  // If there are messages, display them in a ListView
                  return ListView.builder(
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      final AiMessage = chatProvider.messages[index];
                      return AiChatBubble(AiMessage: AiMessage);
                    },
                  );
                },
              ),
            ),
// Loading Indicator!
            Consumer<ChatProvider>(
              builder: (context, chatProvider, child) {
                if (chatProvider.isLoading) {
                  return const CircularProgressIndicator();
                }
                return const SizedBox();
              },
            ), // Consumer

            // USER INPUT BOX (To be implemented)
            Row(
              children: [
                //LEFT -> Text box
                Expanded(
                  child: TextField(controller: _controller),
                ),
                //RIGHT -> Send button
                IconButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      final chatProvider = context.read<ChatProvider>();
                      chatProvider.sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  icon: const Icon(Icons.send),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
