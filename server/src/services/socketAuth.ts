import admin from "firebase-admin";
import type { Server } from "socket.io";

export const authenticateSocket: Parameters<Server["use"]>[0] = async (socket, next) => {
  const token = socket.handshake.auth.token;
  if (!token) {
    console.error("Authentication error: Token not provided");
    return next(new Error("Authentication error"));
  }

  try {
    const decodedToken = await admin.auth().verifyIdToken(token);
    if (decodedToken) {
      socket.data.decodedToken = decodedToken;
      return next();
    }
  } catch (err: any) {
    console.error("Authentication error:", err.message);
    return next(new Error("Authentication error"));
  }
};
