import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/app_shell.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        final chatName = chatProvider.name;

        return AppShell(
          title: chatName,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              },
              icon: const Icon(Icons.view_week),
            ),
          ],
          body: const ChatWidget(), // Use ChatWidget directly
        );
      },
    );
  }
}
