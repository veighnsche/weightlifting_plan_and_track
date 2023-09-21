import 'package:flutter/material.dart';
import '../../models/chat_model.dart';

class SystemMessage extends StatelessWidget {
  final WPTChatMessage message;

  const SystemMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Text(
          message.content!,
          style: TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.grey[800],
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
