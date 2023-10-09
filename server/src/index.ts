import { ApolloServer } from "apollo-server-express";
import cors from "cors";
import { config } from "dotenv";
import express from "express";
import admin from "firebase-admin";
import { execute, subscribe } from "graphql";
import { useServer } from "graphql-ws/lib/use/ws";
import { createServer } from "http";
import "reflect-metadata";
import { Server as WsServer } from "ws";
import { schema } from "./graphql";

import mockRouter from "./mock/mockEvents";
import exerciseRouter from "./models/app/exercises/exerciseEvents";
import workoutRouter from "./models/app/workouts/workoutEvents";
import chatRouter from "./models/chat/chatEvents";
import initRouter from "./models/init/initEvents";
import userRouter from "./models/users/userEvents";
import { authenticateRequest } from "./services/auth";
import { connectDatabase } from "./services/database";
import { connectDatabaseHasura } from "./services/databaseHasura";
import { initializeFirebase } from "./services/firebase";
import { HasuraRESTDataSource } from "./services/hasura";
import { getRateLimiter } from "./services/rateLimiter";

config();

const PORT = process.env.PORT || 3000;

const app = express();

initializeFirebase();

const corsOptions = {
  origin: "*",
  methods: "GET,POST,DELETE",
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true,
};

app.use(cors(corsOptions));
app.use(express.json());
app.use(getRateLimiter());
app.use(authenticateRequest);
app.use("/init", initRouter);
app.use("/user", userRouter);
app.use("/chat", chatRouter);
app.use("/app/workouts", workoutRouter);
app.use("/app/exercises", exerciseRouter);
app.use("/mock", mockRouter);

// expose public folder (../public)
app.use(express.static(__dirname + "/../public"));

const apolloServer = new ApolloServer({
  schema,
  context: ({ req }) => {
    const token = req.headers.authorization || "";
    console.log("Apollo Token:", token);
    return { token };
  },
  dataSources: () => ({
    hasura: new HasuraRESTDataSource(),
  }),
});


// export let connections: Record<string, (() => void)[]> = {};

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

Promise.all([
  connectDatabase(),
  connectDatabaseHasura(),
  apolloServer.start(),
]).then(() => {
  apolloServer.applyMiddleware({ app, path: "/graphql" });

  const httpServer = createServer(app);
  const wsServer = new WsServer({ server: httpServer, path: "/graphql" });

  useServer(
    {
      schema,
      execute,
      subscribe,
      onConnect: async (ctx) => {
        console.log("onConnect");
        const uid = await getUserUid(ctx.extra.request.headers.authorization);
        console.log(uid);

        // if (connections[uid]) {
        //   connections[uid].forEach((unsubscribe) => unsubscribe());
        // }
        // connections[uid] = [];

        console.log("Client connected");
      },
      onDisconnect: async (ctx) => {
        const uid = await getUserUid(ctx.extra.request.headers.authorization);

        // if (connections[uid]) {
        //   connections[uid].forEach((unsubscribe) => unsubscribe());
        // }
        // delete connections[uid];

        console.log("Client disconnected");
      },
      context: async (ctx) => {
        const token = ctx.extra.request.headers.authorization;
        const uid = await getUserUid(token);
        return { token, uid };
      },
    },
    wsServer,
  );

  httpServer.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
  });
});
