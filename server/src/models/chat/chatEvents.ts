import express from "express";
import { callAssistant } from "../../assistant";
import { AuthRequest } from "../../services/auth";
import { addMessage, newChat } from "./chatRepository";

const router = express.Router();

router.post("/", async (req: AuthRequest<{ chatId?: string, message: string }>, res) => {
  const uid = req.user?.uid;

  if (!uid) {
    return res.status(400).send("UID not found.");
  }

  let { chatId, message } = req.body;

  if (!chatId) {
    chatId = await newChat({ userUid: uid, content: message });
    res.status(200).json({ chatId });
  } else {
    await addMessage({ userUid: uid, chatId: chatId, content: message });
    res.sendStatus(204);
  }

  await callAssistant(uid, chatId, message);
});


export default router;