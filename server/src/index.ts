import cors from "cors";
import { config } from "dotenv";
import express from "express";
import rateLimit from "express-rate-limit";
import admin, { ServiceAccount } from "firebase-admin";
import { createServer } from "http";
import { Server } from "socket.io";
// import { createConnection } from 'typeorm'; // Uncomment if you're setting up TypeORM immediately
import serviceAccountKey from "./service-account-key.json";

config(); // Initialize dotenv

const app = express();
const httpServer = createServer(app);
const io = new Server(httpServer, {
  cors: {
    origin: "*", // Adjust this to your client's domain or a list of allowed domains
    methods: ["GET", "POST"],
  },
});

// Firebase Admin SDK initialization
// Make sure to initialize with your serviceAccountKey and databaseURL
admin.initializeApp({
  credential: admin.credential.cert(serviceAccountKey as ServiceAccount),
});

app.use(cors());
app.use(express.json()); // This replaces body-parser for parsing JSON

// Rate limiter middleware
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100, // limit each IP to 100 requests per windowMs
});
app.use(limiter);

app.get("/", (req, res) => {
  res.send("Server is running!");
});

io.on("connection", (socket) => {
  console.log("a user connected");
  socket.on("disconnect", () => {
    console.log("user disconnected");
  });
});

const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});

// Uncomment below if you're setting up TypeORM immediately
// createConnection().then(() => {
//   console.log('Database connected!');
// }).catch(error => console.log(error));
