import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '../services/chat/chat_service.dart';
import '../widgets/app_logo.dart';
import 'chat/message_input.dart';
import 'chat/message_widgets.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({super.key});

  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _contentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();
  List<WPTChatMessage> _messagesCache = [];

  void handleSend(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final messageContent = _contentController.text;

    _chatService.sendMessage(
      chatProvider.chatId,
      messageContent,
      _messagesCache,
      (newChatId) {
        chatProvider.setChatId(newChatId);
        Future.delayed(const Duration(seconds: 10), () {
          if (chatProvider.chatId == null) return;
          _chatService.fetchChatName(chatProvider.chatId!).then((name) {
            chatProvider.setName(name);
          });
        });
      },
    );

    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);
    final chatId = chatProvider.chatId;

    return Column(
      children: [
        Expanded(
          child: StreamBuilder<List<WPTChatMessage>>(
            stream: _chatService.getMessagesStream(chatId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                _messagesCache = [];
                return const Center(
                  child: AppLogo(
                    iconSize: 60,
                    textSize: 16,
                    title: 'Chat with your assistant',
                  ),
                );
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 150),
                  curve: Curves.easeOut,
                );
              });

              List<WPTChatMessage> messages = snapshot.data!;
              _messagesCache = messages;
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
          onSend: () => handleSend(context),
        ),
      ],
    );
  }
}
