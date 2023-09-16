class WPTChatConversation {
  final String conversationID;
  final List<WPTChatMessage> messages;

  WPTChatConversation({required this.conversationID, required this.messages});
}

class WPTChatMessage {
  final String messageID;
  final WPTMessageRole role;
  final String content;
  final Map<String, dynamic>? data;
  final WPTFunctionCall? functionCall;
  final int timestamp;

  WPTChatMessage({
    required this.messageID,
    required this.role,
    required this.content,
    this.data,
    this.functionCall,
    required this.timestamp,
  });
}

enum WPTMessageRole {
  user,
  assistant,
  system,
}

class WPTFunctionCall {
  final String functionName;
  final Map<String, dynamic> parameters;
  final WPTFunctionMetadata metadata;

  WPTFunctionCall({
    required this.functionName,
    required this.parameters,
    required this.metadata,
  });
}

class WPTFunctionMetadata {
  final String callback;
  final WPTFunctionStatus status;

  WPTFunctionMetadata({required this.callback, required this.status});
}

enum WPTFunctionStatus {
  valid,
  invalid,
  replaced,
}
