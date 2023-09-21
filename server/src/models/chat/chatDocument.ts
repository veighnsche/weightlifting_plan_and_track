import { ChatCompletionMessage } from "openai/src/resources/chat/completions";

export interface WPTChatConversation {
  conversationID: string;
  messages: WPTChatMessage[];
}

export interface WPTChatMessage extends ChatCompletionMessage {
  messageID?: string;
  function_call?: WPTFunctionCall;
}

export interface WPTFunctionCall extends ChatCompletionMessage.FunctionCall {
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
