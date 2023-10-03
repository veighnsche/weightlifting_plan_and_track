import express from "express";
import { AuthRequest } from "../../../services/auth";
import { upsertWorkout } from "./workoutRepository";

const router = express.Router();

router.post("/", async (req: AuthRequest, res) => {
  const { uid } = req.user!;

  if (!uid) {
    return res.status(400).send("UID not found.");
  }

  const { workout } = req.body;

  if (!workout) {
    return res.status(400).send("Workout not found.");
  }

  const savedWorkout = await upsertWorkout({ ...workout, user_uid: uid });

  return res.json({ workout: savedWorkout });
});

export default router;