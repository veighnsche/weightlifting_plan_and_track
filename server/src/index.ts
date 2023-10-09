import { config } from "dotenv";
import express from "express";
import { createServer } from "http";
import "reflect-metadata";
import { setupApolloServer } from "./services/apollo";
import { connectDatabase } from "./services/database";
import { connectDatabaseHasura } from "./services/databaseHasura";
import { initializeFirebase } from "./services/firebase";
import { setupMiddlewares } from "./services/middlewares";
import { setupRoutes } from "./services/routes";
import { setupWebSocket } from "./services/websocket";

config();

const PORT = process.env.PORT || 3000;

const app = express();

initializeFirebase();

setupMiddlewares(app);

setupRoutes(app);

const apolloServer = setupApolloServer();

Promise.all([
  connectDatabase(),
  connectDatabaseHasura(),
  apolloServer.start(),
]).then(() => {
  apolloServer.applyMiddleware({ app, path: "/graphql" });
  const httpServer = createServer(app);
  setupWebSocket(httpServer, "/graphql");

  httpServer.listen(PORT, () => {
    console.info(`Server is running on http://localhost:${PORT}`);
  });
});
