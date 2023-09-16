interface WPTChatConversation {
  conversationID: string;
  messages: WPTChatMessage[];
}

interface WPTChatMessage {
  messageID: string;
  role: WPTMessageRole;
  content: string;
  functionCall?: WPTFunctionCall;
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
  Open = 'open',
  Expired = 'expired',
  Approved = 'approved',
  Rejected = 'rejected',
  None = 'none',
}
