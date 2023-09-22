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

  const { chatId, message: content } = req.body;

  try {
    if (!chatId) {
      const newChatId = await newChat({ userUid, content });
      res.status(200).json({ chatId: newChatId });

      const assistantMessage: ChatCompletionMessage = await callAssistant(userUid, newChatId);
      await callNamingAssistant(userUid, newChatId, content, assistantMessage);
    } else {
      await addMessage({ userUid, chatId, content });
      res.sendStatus(204);

      await callAssistant(userUid, chatId);
    }
  } catch (err) {
    // Handle any unexpected errors.
    console.error(err);
    res.status(500).send("Internal server error.");
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