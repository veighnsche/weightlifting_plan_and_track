import admin from "firebase-admin";
import { execute, subscribe } from "graphql";
import { useServer } from "graphql-ws/lib/use/ws";
import type { Server } from "http";

import { Server as WsServer } from "ws";
import { getSchema } from "./graphql";
import { stopHasuraSubscription } from "./hasuraSubscriptions";

export async function setupWebSocket(httpServer: Server, path: string) {
  const schema = await getSchema();

  const wsServer = new WsServer({
    server: httpServer,
    path: path,
    verifyClient: async (info, done) => {
      const bearerToken = info.req.headers.authorization;

      if (!bearerToken) {
        return done(false, 401, "Unauthorized");
      }

      const token = bearerToken.split("Bearer ")[1];

      try {
        await admin.auth().verifyIdToken(token);
        done(true);

      } catch (error) {
        console.error(error);
        done(false, 401, "Unauthorized");
      }
    },
  });

  useServer(
    {
      schema,
      execute,
      subscribe,
      onConnect: async () => {
        console.info("Client connected");
      },
      onDisconnect: async (ctx) => {
        const subscriptionKey = Object.keys(ctx.subscriptions)[0];
        if (!subscriptionKey) return;
        stopHasuraSubscription(subscriptionKey);
        console.info("Client disconnected");
      },
      context: async (ctx) => {
        const subscriptionKey = Object.keys(ctx.subscriptions)[0];
        const token = ctx.extra.request.headers.authorization;
        return { token, subscriptionKey };
      },
      onError: (err) => {
        console.error(err);
      },
    },
    wsServer,
  );
}