import { DecodedIdToken } from "firebase-admin/lib/auth";

export interface ClientToServerEvents {
  // chat conversation events
  "new-user-message": (data: {
    chatId: string;
    message: string;
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
  "pong": (message: string) => void;
}

export interface ServerToClientEvents {
  // chat conversation events
  "new-assistant-message": (message: string) => void;
  "new-system-message": (message: string) => void;

  // chat events
  "chat-history": (data: {
    chatId: string;
    chatTitle: string;
    timestamp: number;
  }[]) => void;

  "chat-messages": (data: {
    chatId: string;
    messages: {
      message: string;
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
  "new-message": (message: string) => void;
}

export interface SocketData {
  // user data
  decodedToken: DecodedIdToken;
}