import { ChatCompletionMessage } from "openai/resources/chat";
import { ChatMessage } from "../chat/chatDocument";

export const removeMetaData = (parameters: Record<string, any>): Record<string, any> => {
  const newParameters: Record<string, any> = {};

  Object.keys(parameters).forEach((key) => {
    if (key !== "content" && key !== "callback") {
      newParameters[key] = parameters[key];
    }
  });

  return newParameters;
};

export const toChatCompletionFunctionCall = (message: ChatMessage): ChatCompletionMessage.FunctionCall => {
  const json = JSON.parse(message.function_call!.arguments);

  if (message.content) {
    json.content = message.content;
  }
  if (message.function_call!.callback) {
    json.callback = message.function_call!.callback;
  }

  return ({
    name: message.function_call!.name,
    arguments: JSON.stringify(json),
  });
};