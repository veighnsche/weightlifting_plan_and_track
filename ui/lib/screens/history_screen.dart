import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/chat_model.dart';
import '../providers/chat_provider.dart';
import '../services/chat/chat_service.dart';

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
                final bool? confirmDelete = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Are you sure you want to delete all conversations?',
                            ),
                            SizedBox(height: 12.0),
                            Text(
                              'Disclaimer: Once conversations are deleted, they cannot be processed for fine-tuning the assistant.',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red.shade300,
                          ),
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                        OutlinedButton(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                      ],
                    );
                  },
                );

                if (confirmDelete == true) {
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
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'delete_all',
                child: ListTile(
                  leading: Icon(Icons.delete_sweep),
                  // Icon for Delete all conversations
                  title: Text('Delete all conversations'),
                ),
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
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No chat history found.'),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      chatProvider.newChat();

                      // Check the current route name
                      String? currentRouteName = ModalRoute.of(context)?.settings.name;

                      // If the current route is not the chat route, navigate to it
                      if (currentRouteName != '/chat') {
                        Navigator.popAndPushNamed(context, '/chat');
                      } else {
                        Navigator.pop(context);
                      }
                    },

                    child: const Text('Go to Chat'),
                  ),
                ],
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                final conversation = snapshot.data![index];

                // Format the updatedAt timestamp into a more readable format.
                final formattedDate = DateFormat('yyyy-MM-dd HH:mm')
                    .format(conversation.updatedAt);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(conversation.name),
                    subtitle: Text(formattedDate),
                    onTap: () {
                      chatProvider.setChatIdAndName(
                        conversation.chatID,
                        conversation.name,
                      );

                      // Check the current route name
                      String? currentRouteName = ModalRoute.of(context)?.settings.name;

                      // If the current route is not the chat route, navigate to it
                      if (currentRouteName != '/chat') {
                        Navigator.popAndPushNamed(context, '/chat');
                      } else {
                        Navigator.pop(context);
                      }
                    },

                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
