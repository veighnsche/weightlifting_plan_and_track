import express from "express";
import { callAssistant } from "../assistant/assistantEvents";
import { AuthRequest } from "../../services/auth";
import { addMessage, deleteChatHistory, fetchChatHistory, newChat } from "./chatRepository";

const router = express.Router();

router.post("/", async (req: AuthRequest<{ chatId?: string, message: string }>, res) => {
  const userUid = req.user?.uid;

  if (!userUid) {
    return res.status(400).send("UID not found.");
  }

  let { chatId, message } = req.body;

  if (!chatId) {
    chatId = await newChat({ userUid, content: message });
    res.status(200).json({ chatId });
  } else {
    await addMessage({ userUid, chatId, content: message });
    res.sendStatus(204);
  }

  await callAssistant(userUid, chatId);
});

router.get("/history", async (req: AuthRequest, res) => {
  const userUid = req.user?.uid;

  if (!userUid) {
    return res.status(400).send("UID not found.");
  }

  const history = await fetchChatHistory(userUid);

  res.status(200).json({ history });
});

router.delete("/history", async (req: AuthRequest, res) => {
  const userUid = req.user?.uid;

  console.log(`Deleting chat history for ${userUid}`);

  if (!userUid) {
    return res.status(400).send("UID not found.");
  }

  try {
    await deleteChatHistory(userUid);
  } catch (error) {
    console.error(error);
    return res.status(500).send("Failed to delete chat history.");
  }

  res.sendStatus(204);
});


export default router;