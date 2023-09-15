import { NextFunction, Request, Response } from "express";
import admin from "firebase-admin";
import type { Server } from "socket.io";

export interface AuthenticatedRequest extends Request {
  user?: admin.auth.DecodedIdToken;
}

export type AuthenticatedMiddleware = (req: AuthenticatedRequest, res: Response, next: NextFunction) => void;

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

export const authenticateRequest: AuthenticatedMiddleware = async (req, res, next) => {
  const token = req.headers.authorization?.split("Bearer ")[1];

  if (!token) {
    return res.status(401).send("Authentication required.");
  }

  try {
    req.user = await admin.auth().verifyIdToken(token);
    next();
  } catch (error) {
    res.status(401).send("Invalid token.");
  }
};