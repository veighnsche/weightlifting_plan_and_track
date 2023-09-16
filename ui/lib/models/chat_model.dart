class WPTChatConversation {
  final String conversationID;
  final List<WPTChatMessage> messages;

  WPTChatConversation({required this.conversationID, required this.messages});

  static WPTChatConversation fromMap(Map<String, dynamic> map) {
    return WPTChatConversation(
      conversationID: map['conversationID'],
      messages: List<WPTChatMessage>.from(map['messages'].map((messageMap) => WPTChatMessage.fromMap('', messageMap))),
    );
  }
}

class WPTChatMessage {
  final String messageID;
  final WPTMessageRole role;
  final String content;
  final WPTFunctionCall? functionCall;

  WPTChatMessage({
    required this.messageID,
    required this.role,
    required this.content,
    this.functionCall,
  });

  static WPTChatMessage fromMap(String id, Map<String, dynamic> map) {
    return WPTChatMessage(
      messageID: id,
      role: WPTMessageRole.values.firstWhere((e) => e.toString() == 'WPTMessageRole.${map['role']}'),
      content: map['content'],
      functionCall: map['functionCall'] != null ? WPTFunctionCall.fromMap(map['functionCall']) : null,
    );
  }
}

enum WPTMessageRole {
  user,
  assistant,
  system,
}

class WPTFunctionCall {
  final String functionName;
  final String parameters;
  final String? callback;
  final WPTFunctionStatus status;

  WPTFunctionCall({
    required this.functionName,
    required this.parameters,
    this.callback,
    required this.status,
  });

  static WPTFunctionCall fromMap(Map<String, dynamic> map) {
    return WPTFunctionCall(
      functionName: map['functionName'],
      parameters: map['parameters'],
      callback: map['callback'],
      status: WPTFunctionStatus.values[map['status']],
    );
  }
}

enum WPTFunctionStatus {
  pending,
  expired,
  approved,
  rejected,
  none,
}
