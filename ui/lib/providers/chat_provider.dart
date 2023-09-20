import 'package:flutter/foundation.dart';

class ChatProvider extends ChangeNotifier {
  String? _chatId = 'MkgFHF6GnFSC9emhKrRh';

  String? get chatId => _chatId;

  void setChatId(String chatId) {
    _chatId = chatId;
    notifyListeners();
  }

  void newChat() {
    _chatId = null;
    notifyListeners();
  }
}