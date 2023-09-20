export interface WPTChatConversation {
  conversationID: string;
  messages: WPTChatMessage[];
}

export interface WPTChatMessage {
  messageID?: string;
  role: WPTMessageRole;
  content: string;
  functionCall?: WPTFunctionCall;
}

export enum WPTMessageRole {
  User = 'user',
  Assistant = 'assistant',
  System = 'system',
}

export interface WPTFunctionCall {
  functionName: string;
  parameters: Record<string, any>;
  callback?: string;  // Making callback optional as per the database table
  status: WPTFunctionStatus;
}

export enum WPTFunctionStatus {
  Pending = 'pending',
  Expired = 'expired',
  Approved = 'approved',
  Rejected = 'rejected',
  None = 'none',
}
