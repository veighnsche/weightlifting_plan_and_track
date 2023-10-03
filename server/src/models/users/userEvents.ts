import express from "express";
import { AuthRequest } from "../../services/auth";
import { UserEntity } from "./userEnitity";
import { findByUid, upsertUser } from "./userRepository";
import { findSettings, upsertSettingsValue } from "./userSettingsRepository";

const router = express.Router();

router.get("/read", async (req: AuthRequest, res) => {
  const uid = req.user?.uid;

  if (!uid) {
    return res.status(400).send("UID not found.");
  }

  const user = await findByUid(uid);
  res.json({ user });
});

router.post("/upsert", async (req: AuthRequest<{ user: Partial<UserEntity> }>, res) => {
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

router.get("/settings", async (req: AuthRequest, res) => {
  const { uid } = req.user!;

  const settings = await findSettings(uid);
  res.json({ settings });
});

router.post("/settings", async (req: AuthRequest<{ settings: Record<string, string> }>, res) => {
  const { settings } = req.body;
  const { uid } = req.user!;

  if (!settings) {
    return res.status(400).send("Settings not found.");
  }

  await upsertSettingsValue(uid, settings);
  res.sendStatus(200);
});

export default router;