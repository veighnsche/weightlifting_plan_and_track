import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_shell.dart';
import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '../services/chat_service.dart';
import '../widgets/app_logo.dart';
import '../widgets/chat/message_input.dart';
import '../widgets/chat/message_widgets.dart';

class ChatScreen extends StatefulWidget {

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _contentController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final ChatService _chatService = ChatService();

  List<WPTChatMessage> _messagesCache = [];

  void handleSend(BuildContext context, List<WPTChatMessage> messages) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    // Get the message content from the controller
    final messageContent = _contentController.text;

    // Send the message using the ChatService and update the chatId if a new one is returned
    _chatService.sendMessage(chatProvider.chatId, messageContent, messages,
        (newChatId) {
      chatProvider.setChatId(newChatId);
      // wait 5 seconds and update the chat name
      Future.delayed(const Duration(seconds: 5), () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (chatProvider.chatId == null) return;
          _chatService.fetchChatName(chatProvider.chatId!).then((name) {
            chatProvider.setName(name);
          });
        });
      });
    });

    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final chatId = chatProvider.chatId;
        final chatName = chatProvider.name;

        return AppShell(
          title: chatName,
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
                      return const Center(
                          child: AppLogo(
                        iconSize: 60,
                        textSize: 16,
                      ));
                    }
                    List<WPTChatMessage> messages = snapshot.data!;
                    _messagesCache = messages;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    });
                    final showLoadingBar = messages.last.isFromUser;
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            controller: _scrollController,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              WPTChatMessage message = messages[index];
                              return ChatMessageWidget(message: message);
                            },
                          ),
                        ),
                        if (showLoadingBar) const LinearProgressIndicator(),
                      ],
                    );
                  },
                ),
              ),
              MessageInput(
                controller: _contentController,
                onSend: () => handleSend(context, _messagesCache),
              ),
            ],
          ),
        );
      },
    );
  }
}
