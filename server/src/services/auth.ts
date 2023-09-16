import { NextFunction, Request, Response } from "express";
import admin from "firebase-admin";

export interface AuthenticatedRequest extends Request {
  user?: admin.auth.DecodedIdToken;
}

export type AuthenticatedMiddleware = (req: AuthenticatedRequest, res: Response, next: NextFunction) => void;

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