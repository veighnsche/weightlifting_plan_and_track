import type { NextFunction, Request, Response } from "express";
import type { ParamsDictionary } from "express-serve-static-core";
import admin from "firebase-admin";
import type { DecodedIdToken } from "firebase-admin/lib/auth";


export interface AuthRequest<T = any> extends Request<ParamsDictionary, any, T> {
  user?: DecodedIdToken;
}

export type AuthMiddleware = (req: AuthRequest, res: Response, next: NextFunction) => void;

export const authenticateRequest: AuthMiddleware = async (req, res, next) => {
  const token = req.headers.authorization?.split("Bearer ")[1];

  if (!token) {
    return res.status(401).send("Authentication required.");
  }

  // console.log(token)

  try {
    req.user = await admin.auth().verifyIdToken(token);
    // console.log(req.user);
    next();
  } catch (error) {
    res.status(401).send("Invalid token.");
  }
};