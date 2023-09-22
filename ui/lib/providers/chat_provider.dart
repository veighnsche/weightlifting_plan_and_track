import 'package:flutter/foundation.dart';

class ChatProvider extends ChangeNotifier {
  String? _chatId;

  String? get chatId => _chatId;

  void setChatId(String chatId) {
    _chatId = chatId;
    notifyListeners();
  }

  String _name = 'New Chat';

  String get name => _name;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void newChat() {
    _chatId = null;
    _name = 'New Chat';
    notifyListeners();
  }

  void setChatIdAndName(String chatId, String name) {
    _chatId = chatId;
    _name = name;
    notifyListeners();
  }
}
