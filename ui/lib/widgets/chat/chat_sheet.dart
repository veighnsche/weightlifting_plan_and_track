import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/chat_model.dart';
import '../../providers/chat_provider.dart';
import '../../services/chat_service.dart';
import '../app_logo.dart';
import 'message_input.dart';
import 'message_widgets.dart';

class ChatSheet extends StatefulWidget {
  ChatSheet({Key? key}) : super(key: key);

  @override
  State<ChatSheet> createState() => _ChatSheetState();
}

class _ChatSheetState extends State<ChatSheet> {
  final TextEditingController _contentController = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  final ChatService _chatService = ChatService();

  List<WPTChatMessage> _messagesCache = [];

  void handleSend(BuildContext context, List<WPTChatMessage> messages) {
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
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          builder: (BuildContext context, ScrollController sheetController) {
            return SafeArea(
              child: Material(
                elevation: 10.0,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          chatProvider.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<List<WPTChatMessage>>(
                          stream: _chatService
                              .getMessagesStream(chatProvider.chatId),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              _messagesCache = [];
                              return const AppLogo(
                                iconSize: 60,
                                textSize: 16,
                                title: 'Chat with your assistant',
                              );
                            }
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
                                      return ChatMessageWidget(
                                          message: message);
                                    },
                                  ),
                                ),
                                if (showLoadingBar)
                                  const LinearProgressIndicator(),
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
                ),
              ),
            );
          },
        );
      },
    );
  }
}
