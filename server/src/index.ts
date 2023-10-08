import { makeExecutableSchema } from "@graphql-tools/schema";
import { ApolloServer, gql } from "apollo-server-express";
import cors from "cors";
import { config } from "dotenv";
import express from "express";
import { execute, subscribe } from "graphql";
import { PubSub } from "graphql-subscriptions";
import { useServer } from "graphql-ws/lib/use/ws";
import { createServer } from "http";
import "reflect-metadata";
import { Server as WsServer } from "ws";

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
import { getRateLimiter } from "./services/rateLimiter";

config();

const pubsub = new PubSub();
const SOMETHING_CHANGED_TOPIC = "somethingChanged";


const typeDefs = gql`
  type Query {
      hello: String
  }
  
  type Subscription {
      somethingChanged: String
  }
`;

const resolvers = {
  Query: {
    hello: () => "Hello world!",
  },
  Subscription: {
    somethingChanged: {
      subscribe: () => pubsub.asyncIterator([SOMETHING_CHANGED_TOPIC]),
    },
  },
};

const PORT = process.env.PORT || 3000;

const app = express();
const schema = makeExecutableSchema({
  typeDefs,
  resolvers,
});

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

app.get("/whatever", async (req, res) => {
  await pubsub.publish(SOMETHING_CHANGED_TOPIC, { somethingChanged: "An update occurred!" }).catch(console.error);
  res.send("Event published!");
});

// expose public folder (../public)
app.use(express.static(__dirname + "/../public"));

const apolloServer = new ApolloServer({
  schema,
  context: ({ req }) => {
    const token = req.headers.authorization || "";
    return { token };
  },
});

const httpServer = createServer(app);
const wsServer = new WsServer({ server: httpServer, path: "/graphql" });

Promise.all([
  connectDatabase(),
  connectDatabaseHasura(),
])
  .then(() => apolloServer.start())
  .then(() => {
    apolloServer.applyMiddleware({ app, path: "/graphql" });

    useServer(
      {
        schema,
        execute,
        subscribe,
        onConnect: () => {
          console.log("Client connected");
        },
        onDisconnect: () => {
          console.log("Client disconnected");
        },
      },
      wsServer,
    );

    httpServer.listen(PORT, () => {
      console.log(`Server is running on http://localhost:${PORT}`);
    });
  });
