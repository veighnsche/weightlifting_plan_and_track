import 'dart:convert';
import 'package:flutter/material.dart';
import '../../models/chat_model.dart';

class FunctionCall extends StatelessWidget {
  final WPTChatMessage message;

  const FunctionCall({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return _buildFunctionCall();
  }

  Widget _buildFunctionCall() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
            // Using the previous background color for the border
            width: 2, // Half-thick border
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.code_outlined,
                    color: Colors.black54, size: 24.0),
                const SizedBox(width: 8.0),
                Text(
                  message.functionCall!.functionName,
                  style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
              ],
            ),
            ..._buildFunctionCallParameters(
                json.decode(message.functionCall!.parameters)),
            const SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  child: const Icon(Icons.close, color: Colors.red),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.check, color: Colors.green),
                      label: const Text("Approve"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green, width: 2.0),
                        // Defining the border color and width
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      label: const Text("Edit"),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.blue,
                        side: const BorderSide(color: Colors.blue, width: 2.0),
                        // Defining the border color and width
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFunctionCallParameters(Map<String, dynamic> parameters) {
    return parameters.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Flexible(
              flex: 2,
              // This gives twice the space to the key compared to the value
              child: Text(
                '${entry.key}:',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis, // Use ellipsis for longer keys
              ),
            ),
            const SizedBox(width: 8.0),
            // A small space between the key and value
            Flexible(
              flex: 3,
              // This gives thrice the space to the value compared to the key
              child: Text(
                entry.value.toString(),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black54,
                ),
                softWrap: true, // Wrap text if it's too long
              ),
            ),
          ],
        ),
      );
    }).toList();
  }
}
