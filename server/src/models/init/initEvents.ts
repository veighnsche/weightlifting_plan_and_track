import express from "express";
import { AuthRequest } from "../../services/auth";
import { functionDefinitions } from "../assistant/functionDefinitions";
import { userExists } from "../users/userRepository";

const router = express.Router();

router.get("/", async (req: AuthRequest, res) => {
  const uid = req.user?.uid;

  if (!uid) {
    return res.status(400).send("UID not found.");
  }

  const onboarded = await userExists(uid);
  res.json({ onboarded, functionDefinitions });
});

export default router;