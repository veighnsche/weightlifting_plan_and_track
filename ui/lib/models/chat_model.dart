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
  final String? content;
  final WPTFunctionCall? functionCall;

  WPTChatMessage({
    required this.messageID,
    required this.role,
    this.content,
    this.functionCall,
  });

  static WPTChatMessage fromMap(String id, Map<String, dynamic> map) {
    return WPTChatMessage(
      messageID: id,
      role: WPTMessageRole.values.firstWhere((e) => e.toString() == 'WPTMessageRole.${map['role']}'),
      content: map['content'],
      functionCall: map['function_call'] != null ? WPTFunctionCall.fromMap(map['function_call']) : null,
    );
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
  final WPTFunctionStatus status;

  WPTFunctionCall({
    required this.name,
    required this.arguments,
    this.callback,
    required this.status,
  });

  static WPTFunctionCall fromMap(Map<String, dynamic> map) {
    return WPTFunctionCall(
      name: map['name'],
      arguments: map['arguments'],
      callback: map['callback'],
      status: WPTFunctionStatus.values.firstWhere((e) => e.toString() == 'WPTFunctionStatus.${map['status']}'),
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
