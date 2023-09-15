import cors from "cors";
import { config } from "dotenv";
import express from "express";
import { createServer } from "http";
import "reflect-metadata";
import { Server } from "socket.io";
import { AppServer } from "./models/socketEvents";
import { registerUserHandlers, userRouter } from "./models/users/userEvents";
import { authenticateRequest, authenticateSocket } from "./services/auth";
import { connectDatabase } from "./services/database";
import { initializeFirebase } from "./services/firebase";
import { getRateLimiter } from "./services/rateLimiter";

config();

const PORT = process.env.PORT || 3000;

const app = express();
const httpServer = createServer(app);
const io: AppServer = new Server(httpServer, {
  cors: {
    origin: "*", methods: ["GET", "POST"],
  },
});

initializeFirebase();

app.use(cors());
app.use(express.json());
app.use(getRateLimiter());
app.use(authenticateRequest);
app.use("/user", userRouter);

io.use(authenticateSocket);

io.on("connection", async (socket) => {
  console.log(`user ${socket.data.decodedToken.name} connected`);

  socket.on("disconnect", () => {
    console.log(`user ${socket.data.decodedToken.name} disconnected`);
  });

  socket.onAny((event, data) => {
    console.log("onAny:", { event, data });
  });

  await registerUserHandlers(socket);
});

connectDatabase().then(() => {
  httpServer.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
  });
});