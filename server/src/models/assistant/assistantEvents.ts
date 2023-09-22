import { OpenAI } from "openai";
import { ChatCompletionMessage } from "openai/resources/chat";
import { WPTChatMessage } from "../chat/chatDocument";
import { addMessage, fetchAllMessages, updateChatName } from "../chat/chatRepository";
import { findSettingsValue } from "../users/userSettingsRepository";
import { removeMetaData, toChatCompletionFunctionCall } from "./assistantUtils";
import { functionCallInfosWithMetadata } from "./functionDefinitions";

const openai = () => new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export const callAssistant = async (uid: string, chatId: string): Promise<ChatCompletionMessage> => {
  const [wptChatMessages, instructions]: [WPTChatMessage[], string | null] = await Promise.all([
    fetchAllMessages(chatId),
    findSettingsValue(uid, "instructions"),
  ]);

  const messages: ChatCompletionMessage[] = [
    { role: "system", content: `I am a helpful gym assistant. ${instructions}` },
    ...wptChatMessages.map((message) => {
      if (message.function_call) {
        return ({
          role: message.role,
          content: null,
          function_call: toChatCompletionFunctionCall(message),
        });
      }

      return ({
        role: message.role,
        content: message.content,
      });
    }),
  ];

  const completion = await openai().chat.completions.create({
    messages,
    model: "gpt-3.5-turbo-0613",
    functions: functionCallInfosWithMetadata,
  });

  if (completion.choices[0].message.content) {
    await addMessage({
      userUid: uid,
      chatId: chatId,
      content: completion.choices[0].message.content,
      role: "assistant",
    });
  } else if (completion.choices[0].message.function_call) {
    const functionCall = completion.choices[0].message.function_call;

    const args = JSON.parse(functionCall.arguments);

    await addMessage({
      userUid: uid,
      chatId: chatId,
      content: args.content,
      role: "assistant",
      functionName: functionCall.name,
      functionArgs: removeMetaData(args),
    });
  }

  return completion.choices[0].message;
};

export const callNamingAssistant = async (userUid: string, chatId: string, content: string, assistantMessage: ChatCompletionMessage) => {
  const completion = await openai().chat.completions.create({
    messages: [
      { role: "user", content },
      assistantMessage,
      { role: "user", content: "Summarize our discussion in 3 words. No punctuation needed. Only display the summary, omit any context." },
    ],
    model: "gpt-3.5-turbo",
    max_tokens: 20,
  });

  if (completion.choices[0].message.content) {
    await updateChatName(userUid, chatId, completion.choices[0].message.content);
  }
};