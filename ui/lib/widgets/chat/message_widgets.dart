import 'package:flutter/material.dart';

import '../../models/chat_model.dart';
import 'assistant_message.dart';
import 'system_message.dart';
import 'user_message.dart';

class ChatMessageWidget extends StatelessWidget {
  final WPTChatMessage message;

  const ChatMessageWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (message.role) {
      case WPTMessageRole.user:
        return UserMessage(message: message);
      case WPTMessageRole.assistant:
        return AssistantMessage(message: message);
      case WPTMessageRole.system:
        return SystemMessage(message: message);
      default:
        return Container();
    }
  }
}
