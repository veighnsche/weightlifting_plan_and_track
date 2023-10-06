import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../chat/chat_sheet.dart';

class ChatBottomSheet {
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Function() onSheetClosed;

  ChatBottomSheet({
    required this.context,
    required this.scaffoldKey,
    required this.onSheetClosed,
  });

  void show({required String name}) {
    Provider.of<ChatProvider>(context, listen: false)
        .newChat("Chatting about $name");

    scaffoldKey.currentState!
        .showBottomSheet((context) {
      return const ChatSheet();
    })
        .closed
        .then((value) {

      onSheetClosed();
    });
  }
}