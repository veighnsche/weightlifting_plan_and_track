import cors from "cors";
import { config } from "dotenv";
import express from "express";
import { createServer } from "http";
import { Server } from "socket.io";
import { ClientToServerEvents, InterServerEvents, ServerToClientEvents, SocketData } from "./events";
import { connectDatabase } from "./services/databaseConnection";
import { initializeFirebase } from "./services/firebase";
import { getRateLimiter } from "./services/rateLimiter";
import { authenticateSocket } from "./services/socketAuth";

config();

const app = express();
const httpServer = createServer(app);
const io: Server<ServerToClientEvents, ClientToServerEvents, InterServerEvents, SocketData> = new Server(httpServer, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
  },
});

initializeFirebase();

app.use(cors());
app.use(express.json());
app.use(getRateLimiter());
io.use(authenticateSocket);

io.on("connection", (socket) => {
  // console.log("user name", socket.data.decodedToken.name);
  console.log(`user ${socket.data.decodedToken.name} connected`);
  socket.on("disconnect", () => {
    console.log("user disconnected");
  });
});

const PORT = process.env.PORT || 3000;

connectDatabase().then(() => {
  httpServer.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
  });
});