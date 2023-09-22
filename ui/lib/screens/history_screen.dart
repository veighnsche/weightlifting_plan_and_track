import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '../services/chat_service.dart';

class HistoryScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();

  HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete_all') {
                bool success = await _chatService.deleteHistory();
                if (success) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Chat history deleted.'),
                      ),
                    );
                    chatProvider.newChat();
                    Navigator.pop(context);
                  });
                }
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete_all',
                child: Text('Delete all conversations'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<WPTChatConversation>>(
        future: _chatService.fetchHistory(),
        builder: (BuildContext context,
            AsyncSnapshot<List<WPTChatConversation>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No chat history found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final conversation = snapshot.data![index];
                return ListTile(
                  title: Text(conversation.name),
                  subtitle: Text(conversation.updatedAt.toString()),
                  onTap: () {
                    chatProvider.setChatId(conversation.chatID);
                    Navigator.pop(context);
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
