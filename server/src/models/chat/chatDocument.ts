import { ChatCompletionMessage } from "openai/src/resources/chat/completions";

export interface WPTChatConversation {
  conversationID: string;
  messages: ChatMessage[];
}

export interface ChatMessage extends ChatCompletionMessage {
  messageID?: string;
  function_call?: FunctionCall;
}

export interface FunctionCall extends ChatCompletionMessage.FunctionCall {
  callback?: string;
}

export enum FunctionStatus {
  Pending = 'pending',
  Expired = 'expired',
  Approved = 'approved',
  Rejected = 'rejected',
  None = 'none',
}
