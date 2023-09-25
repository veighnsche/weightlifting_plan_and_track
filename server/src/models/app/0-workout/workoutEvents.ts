import express from "express";
import { AuthRequest } from "../../../services/auth";
import { findByUserUid, upsertWorkout } from "./workoutRepository";

const router = express.Router();

router.get("/", async (req: AuthRequest, res) => {
  const { uid } = req.user!;

  const workouts = await findByUserUid(uid);

  res.status(200).json({ workouts });
});

router.post("/", async (req: AuthRequest, res) => {
  const { uid } = req.user!;
  const { workout } = req.body;

  if (!workout) {
    return res.status(400).send("Workout not found.");
  }

  await upsertWorkout(uid, workout).then((workout) => {
    res.status(200).json({ workout });
  }).catch((e) => {
    console.error(e);
    res.status(500).send("Error upserting workout");
  });
});

export default router;