interface WPTChatConversation {
  conversationID: string;
  messages: WPTChatMessage[];
}

interface WPTChatMessage {
  messageID: string;
  role: WPTMessageRole;
  content: string;
  data?: Record<string, any>;
  functionCall?: WPTFunctionCall;
  timestamp: number;
}

enum WPTMessageRole {
  User = 'user',
  Assistant = 'assistant',
  System = 'system',
}

interface WPTFunctionCall {
  functionName: string;
  parameters: Record<string, any>;
  metadata: WPTFunctionMetadata;
}

interface WPTFunctionMetadata {
  callback: string;
  status: WPTFunctionStatus;
}

enum WPTFunctionStatus {
  Valid = 'valid',
  Invalid = 'invalid',
  Replaced = 'replaced',
}
