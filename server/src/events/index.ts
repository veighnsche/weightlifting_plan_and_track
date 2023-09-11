import { DecodedIdToken } from "firebase-admin/lib/auth";

export interface ClientToServerEvents {
  // chat conversation events
  "new-user-message": (data: {
    chatId: string;
    content: string;
  }) => void;

  // chat events
  "fetch-chat-history": () => void;

  "fetch-chat-messages": (data: {
    chatId: string;
  }) => void;

  // user events
  "upsert-user": (data: {
    age: number;
    weight: number;
    height: number;
    gymDescription?: string;
  }) => void;

  // misc events
  "pongen": (message: string) => void;
}

export interface ServerToClientEvents {
  // chat conversation events
  "new-assistant-message": (content: string) => void;
  "new-system-message": (content: string) => void;

  // chat events
  "chat-history": (data: {
    chatId: string;
    chatTitle: string;
    timestamp: number;
  }[]) => void;

  "chat-messages": (data: {
    chatId: string;
    messages: {
      content: string;
      role: "user" | "assistant" | "system";
    }[];
  }) => void;

  // user events
  "user-connected": (data: {
    onboarded: boolean;
  }) => void;
}

export interface InterServerEvents {
  // chat events
  "new-message": (content: string) => void;
}

export interface SocketData {
  // user data
  decodedToken: DecodedIdToken;
}