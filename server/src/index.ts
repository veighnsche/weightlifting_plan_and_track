import cors from "cors";
import { config } from "dotenv";
import express from "express";
import { createServer } from "http";
import "reflect-metadata";
import { userRouter } from "./models/users/userEvents";
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
  origin: '*',
  methods: 'GET,POST',
  allowedHeaders: ['Content-Type', 'Authorization'],
  credentials: true,
};

app.use(cors());
app.use(express.json());
app.use(getRateLimiter());
app.use(authenticateRequest);
app.use("/user", userRouter);

connectDatabase().then(() => {
  httpServer.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
  });
});