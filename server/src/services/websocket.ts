import admin from "firebase-admin";
import { execute, subscribe } from "graphql";
import { useServer } from "graphql-ws/lib/use/ws";
import { Server as WsServer } from "ws";
import { getSchema, stopSubscription } from "./graphql";

export async function setupWebSocket(httpServer: any, path: string) {
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
        stopSubscription(subscriptionKey);
        console.info("Client disconnected");
      },
      context: async (ctx) => {
        const subscriptionKey = Object.keys(ctx.subscriptions)[0];
        const token = ctx.extra.request.headers.authorization;
        const uid = await getUserUid(token);
        return { token, uid, subscriptionKey };
      },
      onError: (err) => {
        console.error(err);
      },
    },
    wsServer,
  );
}

async function getUserUid(bearerToken?: string) {
  if (!bearerToken) {
    throw new Error("Missing auth token!");
  }

  const token = bearerToken.split("Bearer ")[1];

  let verified;
  try {
    verified = await admin.auth().verifyIdToken(token);
  } catch (error) {
    throw new Error("Invalid auth token!");
  }

  return verified.uid;
}
