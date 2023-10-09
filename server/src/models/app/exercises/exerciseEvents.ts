import express from "express";
import { AuthRequest } from "../../../services/auth";
import { upsertExercise } from "./exerciseRepository";  // Importing the upsertExercise function

const router = express.Router();

router.post("/", async (req: AuthRequest, res) => {
  const { uid } = req.user!;

  if (!uid) {
    return res.status(400).send("UID not found.");
  }

  const { exercise } = req.body;

  if (!exercise) {
    return res.status(400).send("Exercise not found.");
  }

  const savedExercise = await upsertExercise({ ...exercise, user_uid: uid });

  return res.json({ exercise: savedExercise });
});

export default router;
