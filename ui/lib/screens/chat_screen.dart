import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weightlifting_plan_and_track/providers/chat_provider.dart';

import '../core/app_shell.dart';
import '../models/chat_model.dart';
import '../services/chat_service.dart'; // Import the service class
import '../widgets/chat/message_input.dart';
import '../widgets/chat/message_widgets.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _contentController = TextEditingController();
  final ChatService _chatService = ChatService();

  ChatScreen({super.key});

  void handleSend() {
    // send message to the backend
    // You can also use the ChatService to send messages to Firebase.
    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final chatId = chatProvider.chatId;

        print('chatId: $chatId');

        return AppShell(
          title: 'Chat',
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<WPTChatMessage>>(
                  stream: _chatService.getMessagesStream(chatId),
                  // This creates a new stream when chatId changes
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No messages yet.'));
                    }
                    List<WPTChatMessage> messages = snapshot.data!;
                    return ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        WPTChatMessage message = messages[index];
                        return ChatMessageWidget(message: message);
                      },
                    );
                  },
                ),
              ),
              MessageInput(controller: _contentController, onSend: handleSend),
            ],
          ),
        );
      },
    );
  }
}
