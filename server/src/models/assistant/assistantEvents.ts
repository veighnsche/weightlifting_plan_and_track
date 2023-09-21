import { OpenAI } from "openai";
import { ChatCompletionMessage } from "openai/resources/chat";
import { WPTChatMessage } from "../chat/chatDocument";
import { addMessage, fetchAllMessages } from "../chat/chatRepository";
import { findSettingsValue } from "../users/userSettingsRepository";
import { functionCallInfosWithMetadata } from "./functionDefinitions";

export const callAssistant = async (uid: string, chatId: string) => {
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
  });

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
      role: "assistant",
    });
  } else if (completion.choices[0].message.function_call) {
    const functionCall = completion.choices[0].message.function_call;

    console.log(functionCall);

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
};

const removeMetaData = (parameters: Record<string, any>): Record<string, any> => {
  const newParameters: Record<string, any> = {};

  Object.keys(parameters).forEach((key) => {
    if (key !== "content" && key !== "callback") {
      newParameters[key] = parameters[key];
    }
  });

  return newParameters;
};

const toChatCompletionFunctionCall = (message: WPTChatMessage): ChatCompletionMessage.FunctionCall => {
  const json = JSON.parse(message.function_call!.arguments);

  // add content and callback from the message to the json
  json.content = message.content;
  if (message.function_call!.callback) {
    json.callback = message.function_call!.callback;
  }

  return ({
    name: message.function_call!.name,
    arguments: JSON.stringify(json),
  });
};