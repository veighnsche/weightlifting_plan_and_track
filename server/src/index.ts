import cors from "cors";
import { config } from "dotenv";
import express from "express";
import { createServer } from "http";
import "reflect-metadata";
import initRouter from "./models/init/initEvents";
import userRouter from "./models/users/userEvents";
import chatRouter from "./models/chat/chatEvents";

import { authenticateRequest } from "./services/auth";
import { connectDatabase } from "./services/database";
import { initializeFirebase } from "./services/firebase";
import { getRateLimiter } from "./services/rateLimiter";

config();

const PORT = process.env.PORT || 3000;

const app = express();
const httpServer = createServer(app);

initializeFirebase();

const corsOptions = {
  origin: "*",
  methods: "GET,POST",
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

connectDatabase().then(() => {
  httpServer.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
  });
});