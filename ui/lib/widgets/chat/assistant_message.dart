import 'package:flutter/material.dart';

import '../../models/chat_model.dart';
import 'function_call_message.dart';

class AssistantMessage extends StatelessWidget {
  final WPTChatMessage message;

  const AssistantMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.content != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              margin:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                message.content!,
                style: const TextStyle(fontSize: 18.0, color: Colors.black87),
              ),
            ),
          ),
        if (message.functionCall != null) FunctionCallMessage(message: message),
      ],
    );
  }
}
