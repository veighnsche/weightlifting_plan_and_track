import { dataSource } from "../../services/database";
import { getDatabase } from "../../services/firebase";
import { WPTChatMessage, WPTMessageRole } from "./chatDocument";
import { ChatEntity } from "./chatEntity";

const chatRepository = dataSource.getRepository(ChatEntity);

export const newChat = async (userUid: string, message: string): Promise<string> => {
  const db = getDatabase();
  const conversationsRef = db.collection("conversations");
  const conversationRef = await conversationsRef.add({});

  const chatEntity = new ChatEntity();
  chatEntity.userUid = userUid;
  chatEntity.chatId = conversationRef.id;
  chatEntity.name = "Test User";
  chatEntity.updatedAt = new Date();
  await chatRepository.save(chatEntity);

  const wptChatMessage: WPTChatMessage = {
    role: WPTMessageRole.User,
    content: message,
  };

  const messageId = `${chatEntity.updatedAt?.getTime()}`;
  await conversationRef.collection("messages").doc(messageId).set(wptChatMessage);

  return conversationRef.id;
};

export const addUserMessage = async (userUid: string, chatId: string, content: string): Promise<void> => {
  const chatEntity = await chatRepository.findOneBy({ userUid, chatId });

  if (!chatEntity) {
    throw new Error(`Chat with ID ${chatId} not found for user ${userUid}`);
  }

  chatEntity.updatedAt = new Date();
  await chatRepository.save(chatEntity);

  const db = getDatabase();
  const conversationsRef = db.collection("conversations");
  const conversationRef = conversationsRef.doc(chatId);

  const wptChatMessage: WPTChatMessage = {
    role: WPTMessageRole.User,
    content,
  };

  // Using the current timestamp as the document ID
  const messageId = `${chatEntity.updatedAt?.getTime()}`;
  await conversationRef.collection("messages").doc(messageId).set(wptChatMessage);
};


export const addAssistantMessage = async (userUid: string, chatId: string, content: string): Promise<void> => {
  const chatEntity = await chatRepository.findOneBy({ userUid, chatId });

  if (!chatEntity) {
    throw new Error(`Chat with ID ${chatId} not found for user ${userUid}`);
  }

  chatEntity.updatedAt = new Date();
  await chatRepository.save(chatEntity);

  const db = getDatabase();
  const conversationsRef = db.collection("conversations");
  const conversationRef = conversationsRef.doc(chatId);

  const wptChatMessage: WPTChatMessage = {
    role: WPTMessageRole.Assistant,
    content,
  }

  // Using the current timestamp as the document ID
  const messageId = `${chatEntity.updatedAt?.getTime()}`;
  await conversationRef.collection("messages").doc(messageId).set(wptChatMessage);
}
//
// export const addSystemMessage = async (chatId: string, content: string): Promise<void> => {
//   return;
// }