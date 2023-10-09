import type { NextFunction, Request, Response } from "express";
import type { ParamsDictionary } from "express-serve-static-core";
import admin from "firebase-admin";
import type { DecodedIdToken } from "firebase-admin/lib/auth";


export interface AuthRequest<T = any> extends Request<ParamsDictionary, any, T> {
  user?: DecodedIdToken;
}

export type AuthMiddleware = (req: AuthRequest, res: Response, next: NextFunction) => void;

const HARDCODED_PASSWORD = "S3cureP@ssw0rd!";

export const authenticateRequest: AuthMiddleware = async (req, res, next) => {
  // Check if route is GET "/mock"
  if (req.method === "GET" && req.path === "/mock") {
    const password = req.headers["x-mock-password"];
    if (password !== HARDCODED_PASSWORD) {
      return res.status(403).send("Forbidden: Invalid password for mock endpoint.");
    }
    return next();
  }

  // Check is path starts with "/graphql"
  if (req.path.startsWith("/graphql")) {
    console.log("GraphQL request, continuing...")
    return next();
  }
  //
  // if (req.method === "GET" && req.path === "/whatever") {
  //   return next();
  // }

  // console.log("Not a dev request, continuing...", req.method, req.path);

  const token = req.headers.authorization?.split("Bearer ")[1];
  // console.log(req.path, "Token:", token);
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
