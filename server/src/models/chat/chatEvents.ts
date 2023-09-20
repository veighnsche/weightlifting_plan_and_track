import express from "express";
import { callAssistant } from "../../assistant";
import { AuthRequest } from "../../services/auth";
import { addUserMessage, newChat } from "./chatRepository";

const router = express.Router();

router.post("/", async (req: AuthRequest<{ chatId?: string, message: string }>, res) => {
  const uid = req.user?.uid;

  if (!uid) {
    return res.status(400).send("UID not found.");
  }

  let { chatId, message } = req.body;

  if (!chatId) {
    chatId = await newChat(uid, message);
    res.status(200).json({ chatId });
  } else {
    await addUserMessage(uid, chatId, message);
    res.sendStatus(204);
  }

  await callAssistant(uid, chatId, message)
});


export default router;