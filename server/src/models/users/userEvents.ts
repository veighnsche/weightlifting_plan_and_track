import express from "express";
import { AuthenticatedRequest } from "../../services/auth";
import { AppSocket } from "../socketEvents";
import { upsertUser, userExists } from "./userRepository";

const router = express.Router();

router.get("/check-onboarding", async (req: AuthenticatedRequest, res) => {
  const uid = req.user?.uid;

  if (!uid) {
    return res.status(400).send("UID not found.");
  }

  const onboarded = await userExists(uid);
  res.json({ onboarded });
});

export const userRouter = router;

export const registerUserHandlers = async (socket: AppSocket) => {
  socket.on("upsert-user", async ({ user }, ackCallback) => {
    const { uid, name } = socket.data.decodedToken;
    await upsertUser({ ...user, name, uid }).then(() => {
      ackCallback({});
    }).catch((e) => {
      console.error(e);
      ackCallback({ error: "Error upserting user" });
    });
  });
};