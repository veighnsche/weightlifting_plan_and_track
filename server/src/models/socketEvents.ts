import { DecodedIdToken } from "firebase-admin/lib/auth";
import { Server, Socket } from "socket.io";

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
    user: {
      age?: number;
      weight?: number;
      height?: number;
      gymDescription?: string;
    }
  }) => void;
}

export interface ServerToClientEvents {
  // chat conversation events
  "new-assistant-message": (data: {
    chatId: string;
    content: string;
  }) => void;

  "new-system-message": (data: {
    chatId: string;
    content: string;
  }) => void;

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
}

export interface SocketData {
  // user data
  decodedToken: DecodedIdToken;
}

export type AppSocket = Socket<ClientToServerEvents, ServerToClientEvents, InterServerEvents, SocketData>;
export type AppServer = Server<ClientToServerEvents, ServerToClientEvents, InterServerEvents, SocketData>;
