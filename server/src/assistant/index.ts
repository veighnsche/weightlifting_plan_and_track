import { OpenAI } from "openai";
import { addAssistantMessage } from "../models/chat/chatRepository";

export const callAssistant = async (uid: string, chatId: string, message: string) => {
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
  });

  const completion = await openai.chat.completions.create({
    messages: [
      { role: "system", content: "I am a helpful gym assistant." },
      { role: "user", content: message },
    ],
    model: "gpt-3.5-turbo-0613",
  });

  if (!completion.choices[0].message.content) {
    throw new Error("No response from OpenAI");
  }

  await addAssistantMessage(uid, chatId, completion.choices[0].message.content);
};