import express from "express";
import { ChatCompletionMessage } from "openai/resources/chat";
import { Scr1WorkoutList } from "../../graphql/screens/scr1WorkoutList";
import { AuthRequest } from "../../services/auth";
import { callAssistant, callNamingAssistant } from "../assistant/assistantEvents";
import { ChatMessage } from "./chatDocument";
import { addMessage, deleteChatHistory, fetchChatHistory, getChatName, newChat } from "./chatRepository";

const router = express.Router();

router.post("/", async (req: AuthRequest<{ chatId?: string, message: string, messages: ChatMessage[], systemData?: Scr1WorkoutList }>, res) => {
  const userUid = req.user?.uid;

  if (!userUid) {
    return res.status(400).send("UID not found.");
  }

  const { chatId, message: content, messages, systemData } = req.body;

  const systemDataMessage: ChatMessage | undefined = systemData ? {
    role: "system",
    content: JSON.stringify(systemData),
  } : undefined;

  const combinedMessages = [...messages, ...(systemDataMessage ? [systemDataMessage] : [])];

  try {
    if (!chatId) {
      const { chatId: newChatId, chatMessage } = await newChat({ userUid, content });
      await handleNewChat(userUid, newChatId, combinedMessages, chatMessage, content);
      res.status(200).json({ chatId: newChatId, message: chatMessage });
    } else {
      const chatMessage = await addMessage({ userUid, chatId, content });
      await callAssistant(userUid, chatId, [...combinedMessages, chatMessage]);
      res.status(200).json({ message: chatMessage });
    }
  } catch (err) {
    console.error(err);
    res.status(500).send("Internal server error.");
  }
});

async function handleNewChat(userUid: string, chatId: string, messages: ChatMessage[], chatMessage: ChatMessage, content: string) {
  const assistantMessage: ChatCompletionMessage = await callAssistant(userUid, chatId, [...messages, chatMessage]);
  await callNamingAssistant(userUid, chatId, content, assistantMessage);
}



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

  console.info(`Deleting chat history for ${userUid}`);

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