import 'package:flutter/material.dart';
import '../core/app_shell.dart';
import '../models/chat_model.dart';
import '../widgets/chat_message_widgets.dart';
import '../widgets/message_input.dart';
import '../services/chat_service.dart'; // Import the service class

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _contentController = TextEditingController();
  final ChatService _chatService = ChatService();

  void handleSend() {
    // send message to the backend
    // You can also use the ChatService to send messages to Firebase.
    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Chat',
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<WPTChatMessage>>(
              future: _chatService.getMessages(),
              builder: (context, snapshot) {
                print("snapshot.connectionState ${snapshot.connectionState}");

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                print("snapshot.data $snapshot.data");

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages yet.'));
                }

                List<WPTChatMessage>? messages = snapshot.data;

                return ListView.builder(
                  itemCount: messages?.length,
                  itemBuilder: (context, index) {
                    WPTChatMessage message = messages![index];
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
  }
}
