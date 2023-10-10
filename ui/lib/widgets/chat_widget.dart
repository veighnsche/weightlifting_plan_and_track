import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weightlifting_plan_and_track/services/chat/chat_wpt_store_service.dart';

import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '../services/chat/chat_service.dart';
import '../widgets/app_logo.dart';
import 'app_chat/system_message_grid.dart';
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
  final ChatWptStoreService _chatWptStoreService = ChatWptStoreService();

  List<WPTChatMessage> _messagesCache = [];

  void handleSend(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final messageContent = _contentController.text;

    _chatService.sendMessage(
      chatId: chatProvider.chatId,
      message: messageContent,
      messages: _messagesCache,
      systemData: _chatWptStoreService.getWpt(),
      updateChatId: (newChatId) {
        chatProvider.setChatId(newChatId);
        Future.delayed(const Duration(seconds: 10), () {
          if (chatProvider.chatId == null) return;
          _chatService.fetchChatName(chatProvider.chatId!).then((name) {
            chatProvider.setName(name);
          });
        });
      },
    );

    _chatWptStoreService.clearStore();
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
                return Column(
                  children: [
                    if (_chatWptStoreService.hasData)
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ChatWptGridWidget(),
                        ),
                      ),
                    const Expanded(
                      child: Center(
                        child: AppLogo(
                          iconSize: 60,
                          textSize: 16,
                          title: 'Chat with your assistant',
                        ),
                      ),
                    ),
                  ],
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

              final itemCount =
                  messages.length + (_chatWptStoreService.hasData ? 1 : 0);

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: itemCount,
                      itemBuilder: (context, index) {
                        if (_chatWptStoreService.hasData &&
                            index == itemCount - 1) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ChatWptGridWidget(),
                          );
                        }

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

  @override
  void dispose() {
    _contentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
