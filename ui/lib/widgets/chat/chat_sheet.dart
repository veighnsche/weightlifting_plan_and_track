import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../chat_widget.dart';

class ChatSheet extends StatelessWidget {

  const ChatSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, _) {
        return DraggableScrollableSheet(
          initialChildSize: 1,
          builder: (BuildContext context, ScrollController sheetController) {
            return SafeArea(
              child: Material(
                elevation: 15.0, // Increased elevation
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],  // Darker background
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                    boxShadow: const [ // Drop shadow
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, -2),
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 12.0, bottom: 6.0), // Increased spacing
                        width: 50.0,
                        height: 5.0,
                        decoration: BoxDecoration(
                          color: Colors.black12, // Darker indicator color
                          borderRadius: BorderRadius.circular(3.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),  // Increased padding
                        child: Text(
                          chatProvider.name,
                          style: TextStyle(
                            fontSize: 20,  // Increased font size
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],  // Darker font color
                          ),
                        ),
                      ),
                      const Expanded(
                        child: ChatWidget(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
