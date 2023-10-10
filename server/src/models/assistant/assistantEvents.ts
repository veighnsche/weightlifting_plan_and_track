import { OpenAI } from "openai";
import { ChatCompletionMessage } from "openai/resources/chat";
import { ChatMessage } from "../chat/chatDocument";
import { addMessage, updateChatName } from "../chat/chatRepository";
import { findByUid } from "../users/userRepository";
import { findSettingsValue } from "../users/userSettingsRepository";
import { removeMetaData, toChatCompletionFunctionCall } from "./assistantUtils";
import { functionCallInfosWithMetadata } from "./functionDefinitions";

const openai = () => new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export const callAssistant = async (uid: string, chatId: string, ChatMessages: ChatMessage[]): Promise<ChatCompletionMessage> => {
  const [extraInstructions, userDetails] = await Promise.all([
    findSettingsValue(uid, "instructions"),
    findByUid(uid),
  ]);

  const fullSystemInstructions = `As a digital gym assistant, your core responsibility is to efficiently manage data for a gym app. This encompasses handling function calls related to gym activities, tracking user progress, and addressing general app inquiries. Furthermore, ${extraInstructions}. In all your interactions, prioritize accuracy, deliver prompt responses, and ensure the experience is consistently user-friendly. Your guidance is vital as gym-goers rely on your diligence to navigate their fitness journey.
Meet ${userDetails?.name}, a ${userDetails?.age}-year-old fitness enthusiast. Weighing ${userDetails?.weight} kg and standing at ${userDetails?.height} cm, they currently have a body fat of ${userDetails?.fatPercentage}%. They work out at their favorite gym, described as ${userDetails?.gymDescription}.`;

  const messages: ChatCompletionMessage[] = [
    { role: "system", content: fullSystemInstructions },
    ...ChatMessages.map((message) => {
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
      {
        role: "user",
        content: "Summarize our discussion in three (3) short and simple words. No punctuation needed. Only display the summary, omit any context.",
      },
    ],
    model: "gpt-3.5-turbo",
    max_tokens: 20,
  });

  if (completion.choices[0].message.content) {
    await updateChatName(userUid, chatId, completion.choices[0].message.content);
  }
};
