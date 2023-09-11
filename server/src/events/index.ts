import { DecodedIdToken } from "firebase-admin/lib/auth";

export interface ServerToClientEvents {
  // chat events
  "new-assistant-message": (message: string) => void;
  "new-system-message": (message: string) => void;

  // user events
  "initialize-user": (onboard: boolean) => void;
}

export interface ClientToServerEvents {
  // chat events
  "new-user-message": (message: string) => void;
}

export interface InterServerEvents {
  // chat events
  "new-message": (message: string) => void;
}

export interface SocketData {
  // user data
  decodedToken: DecodedIdToken;
}