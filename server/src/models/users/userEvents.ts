import express from "express";
import { AuthenticatedRequest } from "../../services/auth";
import { upsertUser, userExists } from "./userRepository";

const router = express.Router();

router.get("/check-onboarding", async (req: AuthenticatedRequest, res) => {
  const uid = req.user?.uid;

  console.info(`Checking onboarding for user ${uid}`);

  if (!uid) {
    return res.status(400).send("UID not found.");
  }

  const onboarded = await userExists(uid);
  res.json({ onboarded });
});

router.post("/upsert", async (req: AuthenticatedRequest, res) => {
  const { user } = req.body;
  const { uid, name } = req.user!;

  if (!user) {
    return res.status(400).send("User not found.");
  }

  await upsertUser({ ...user, name, uid }).then(() => {
    res.sendStatus(200);
  }).catch((e) => {
    console.error(e);
    res.status(500).send("Error upserting user");
  });
});

export const userRouter = router;