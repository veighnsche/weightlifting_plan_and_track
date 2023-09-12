import 'package:flutter/material.dart';

import '../core/app_shell.dart';
import '../services/socket_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SocketService _socketService = SocketService();
  final TextEditingController _contentController = TextEditingController();

  final List<ChatMessage> messages = [];

  void handleSend() {
    _socketService.sendMessage(_contentController.text);

    setState(() {
      messages.add(
          ChatMessage(content: _contentController.text, role: UserRole.user));
    });

    _contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Chat',
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                ChatMessage message = messages[index];
                switch (message.role) {
                  case UserRole.user:
                    return _buildUserMessage(message);
                  case UserRole.assistant:
                    return _buildAssistantMessage(message);
                  case UserRole.system:
                    return _buildSystemMessage(message);
                  default:
                    return Container();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 20.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide:
                            const BorderSide(color: Colors.blue, width: 2.0),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: handleSend,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserMessage(ChatMessage message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message.content,
          style: const TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildAssistantMessage(ChatMessage message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message.content,
          style: const TextStyle(fontSize: 18.0, color: Colors.black87),
        ),
      ),
    );
  }

  Widget _buildSystemMessage(ChatMessage message) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
        child: Text(
          message.content,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey[600],
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}

class ChatMessage {
  final String content;
  final UserRole role;

  ChatMessage({required this.content, required this.role});
}

enum UserRole { user, assistant, system }
