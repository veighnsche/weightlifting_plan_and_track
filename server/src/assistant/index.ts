import { OpenAI } from "openai";
import { ChatCompletionMessage } from "openai/resources/chat";
import { WPTChatMessage, WPTMessageRole } from "../models/chat/chatDocument";
import { addMessage, fetchAllMessages } from "../models/chat/chatRepository";
import { functionCallInfosWithMetadata } from "./functionCallInfo";

export const callAssistant = async (uid: string, chatId: string) => {
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
  });

  const wptChatMessages: WPTChatMessage[] = await fetchAllMessages(chatId);

  const messages: ChatCompletionMessage[] = [
    { role: "system", content: "I am a helpful gym assistant." },
    ...wptChatMessages.map((message) => ({
      role: message.role,
      content: message.content,
    })),
  ];

  const completion = await openai.chat.completions.create({
    messages,
    model: "gpt-3.5-turbo-0613",
    functions: functionCallInfosWithMetadata,
  });

  if (completion.choices[0].message.content) {
    await addMessage({
      userUid: uid,
      chatId: chatId,
      content: completion.choices[0].message.content,
      role: WPTMessageRole.Assistant,
    });
  } else if (completion.choices[0].message.function_call) {
    const functionCall = completion.choices[0].message.function_call;

    console.log(functionCall)

    const parameters = JSON.parse(functionCall.arguments);

    await addMessage({
      userUid: uid,
      chatId: chatId,
      content: parameters.content,
      role: WPTMessageRole.Assistant,
      functionName: functionCall.name,
      parameters: removeMetaData(parameters),
    });
  }
};

const removeMetaData = (parameters: Record<string, any>): Record<string, any> => {
  const newParameters: Record<string, any> = {};

  Object.keys(parameters).forEach((key) => {
    if (key !== "content" && key !== "callback") {
      newParameters[key] = parameters[key];
    }
  });

  return newParameters;
}