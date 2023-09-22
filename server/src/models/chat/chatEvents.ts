import express from "express";
import { ChatCompletionMessage } from "openai/resources/chat";
import { callAssistant, callNamingAssistant } from "../assistant/assistantEvents";
import { AuthRequest } from "../../services/auth";
import { addMessage, deleteChatHistory, fetchChatHistory, getChatName, newChat } from "./chatRepository";

const router = express.Router();

router.post("/", async (req: AuthRequest<{ chatId?: string, message: string }>, res) => {
  const userUid = req.user?.uid;

  if (!userUid) {
    return res.status(400).send("UID not found.");
  }

  let { chatId, message } = req.body;

  const isNewChat = !chatId;

  if (!chatId) {
    chatId = await newChat({ userUid, content: message });
    res.status(200).json({ chatId });
  } else {
    await addMessage({ userUid, chatId, content: message });
    res.sendStatus(204);
  }

  const assistantMessage: ChatCompletionMessage = await callAssistant(userUid, chatId);

  if (isNewChat) {
    await callNamingAssistant(userUid, chatId, message, assistantMessage);
  }
});

router.get("/:chatId/name", async (req: AuthRequest, res) => {
  const userUid: string = req.user!.uid;
  const chatId: string = req.params.chatId;

  const name = await getChatName(userUid, chatId);

  res.status(200).json({ name });
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