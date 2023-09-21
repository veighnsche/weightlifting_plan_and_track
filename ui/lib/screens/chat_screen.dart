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
  final ScrollController _scrollController = ScrollController();

  final ChatService _chatService = ChatService();

  ChatScreen({super.key});

  void handleSend(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    // Get the message content from the controller
    final messageContent = _contentController.text;

    // Send the message using the ChatService and update the chatId if a new one is returned
    _chatService.sendMessage(chatProvider.chatId, messageContent, (newChatId) {
      chatProvider.setChatId(newChatId);
    });

    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final chatId = chatProvider.chatId;

        return AppShell(
          title: 'Chat',
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder<List<WPTChatMessage>>(
                  stream: _chatService.getMessagesStream(chatId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No messages yet.'));
                    }
                    List<WPTChatMessage> messages = snapshot.data!;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        WPTChatMessage message = messages[index];
                        return ChatMessageWidget(message: message);
                      },
                    );
                  },
                ),
              ),
              MessageInput(
                controller: _contentController,
                onSend: () => handleSend(context),
              ),
            ],
          ),
        );
      },
    );
  }
}
