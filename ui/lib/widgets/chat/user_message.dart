import 'package:flutter/material.dart';
import '../../models/chat_model.dart';

class UserMessage extends StatelessWidget {
  final WPTChatMessage message;

  const UserMessage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueGrey[600]!, Colors.blueGrey[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
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
          style: const TextStyle(fontSize: 18.0, color: Colors.white),
        ),
      ),
    );
  }
}
