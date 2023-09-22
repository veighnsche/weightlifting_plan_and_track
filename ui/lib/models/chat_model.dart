class WPTChatMessages {
  final String conversationID;
  final List<WPTChatMessage> messages;

  WPTChatMessages({required this.conversationID, required this.messages});

  static WPTChatMessages fromMap(Map<String, dynamic> map) {
    return WPTChatMessages(
      conversationID: map['conversationID'],
      messages: List<WPTChatMessage>.from(map['messages']
          .map((messageMap) => WPTChatMessage.fromMap('', messageMap))),
    );
  }
}

class WPTChatMessage {
  final String messageID;
  final WPTMessageRole role;
  final String? content;
  final WPTFunctionCall? functionCall;

  bool get isFromUser => role == WPTMessageRole.user;

  WPTChatMessage({
    required this.messageID,
    required this.role,
    this.content,
    this.functionCall,
  });

  static WPTChatMessage fromMap(String id, Map<String, dynamic> map) {
    return WPTChatMessage(
      messageID: id,
      role: WPTMessageRole.values
          .firstWhere((e) => e.toString() == 'WPTMessageRole.${map['role']}'),
      content: map['content'],
      functionCall: map['function_call'] != null
          ? WPTFunctionCall.fromMap(map['function_call'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'role': role.toString().split('.').last,
      'content': content,
      'function_call': functionCall?.toMap(),
    };
  }
}

enum WPTMessageRole {
  user,
  assistant,
  system,
  function,
}

class WPTFunctionCall {
  final String name;
  final String arguments;
  final String? callback;

  WPTFunctionCall({
    required this.name,
    required this.arguments,
    this.callback,
  });

  static WPTFunctionCall fromMap(Map<String, dynamic> map) {
    return WPTFunctionCall(
      name: map['name'],
      arguments: map['arguments'],
      callback: map['callback'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'arguments': arguments,
      'callback': callback,
    };
  }
}

class WPTChatConversation {
  final String chatID;
  final String name;
  final DateTime updatedAt;

  WPTChatConversation({
    required this.chatID,
    required this.name,
    required this.updatedAt,
  });

  static WPTChatConversation fromMap(Map<String, dynamic> map) {
    return WPTChatConversation(
      chatID: map['chatId'],
      name: map['name'],
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  static List<WPTChatConversation> fromMapList(List<dynamic> mapList) {
    List<WPTChatConversation> chats = List<WPTChatConversation>.from(
      mapList.map((map) => WPTChatConversation.fromMap(map)),
    )..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return chats;
  }
}
