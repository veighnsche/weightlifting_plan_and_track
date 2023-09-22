import { ChatCompletionRole } from "openai/src/resources/chat/completions";
import { dataSource } from "../../services/database";
import { getDatabase } from "../../services/firebase";
import { WPTChatMessage } from "./chatDocument";
import { ChatEntity } from "./chatEntity";

interface BaseMessageParams {
  userUid: string;
  chatId?: string;
  content?: string;
  role?: ChatCompletionRole;
  functionName?: string;
  functionArgs?: Record<string, any>;
  functionCallback?: string;
}

const chatRepository = dataSource.getRepository(ChatEntity);

/**
 * Fetch and update chat entity from the primary database.
 */
const fetchAndUpdateChatEntity = async (userUid: string, chatId: string): Promise<ChatEntity> => {
  const chatEntity = await chatRepository.findOneBy({ userUid, chatId });

  if (!chatEntity) {
    throw new Error(`Chat with ID ${chatId} not found for user ${userUid}`);
  }

  chatEntity.updatedAt = new Date();
  await chatRepository.save(chatEntity);

  return chatEntity;
};

/**
 * Save a message to Firestore.
 */
const saveMessageToFirestore = async (chatId: string, message: WPTChatMessage): Promise<void> => {
  const db = getDatabase();
  const conversationsRef = db.collection("conversations");
  const conversationRef = conversationsRef.doc(chatId);

  const messageId = `${new Date().getTime()}-${Math.floor(Math.random() * 1000)}`; // Added randomness to reduce conflict chances
  await conversationRef.collection("messages").doc(messageId).set(message);
};

export const newChat = async ({ userUid, content }: BaseMessageParams): Promise<{
  chatId: string;
  wptChatMessage: WPTChatMessage;
}> => {
  const db = getDatabase();
  const conversationsRef = db.collection("conversations");
  const conversationRef = await conversationsRef.add({});

  const chatEntity = new ChatEntity();
  chatEntity.userUid = userUid;
  chatEntity.chatId = conversationRef.id;
  chatEntity.name = "New Chat";
  chatEntity.updatedAt = new Date();
  await chatRepository.save(chatEntity);

  const wptChatMessage: WPTChatMessage = {
    role: "user",
    content: content!,
  };

  await saveMessageToFirestore(conversationRef.id, wptChatMessage);

  return {
    chatId: conversationRef.id,
    wptChatMessage,
  };
};

export const addMessage = async ({
  chatId,
  content,
  functionName,
  functionArgs,
  functionCallback,
  role,
  userUid,
}: BaseMessageParams): Promise<WPTChatMessage> => {
  if (!userUid || !chatId) {
    throw new Error(`Invalid parameters provided. userUid: ${userUid}, chatId: ${chatId}`);
  }

  const chatEntity = await fetchAndUpdateChatEntity(userUid, chatId);

  const wptChatMessage: WPTChatMessage = {
    role: role ?? "user",
    content: content ?? null,
  };

  if (role === "assistant" && functionName && functionArgs) {
    wptChatMessage.function_call = {
      name: functionName,
      arguments: JSON.stringify(functionArgs),
    };

    if (functionCallback) {
      wptChatMessage.function_call!.callback = functionCallback;
    }
  }

  await saveMessageToFirestore(chatEntity.chatId, wptChatMessage);

  return wptChatMessage;
};

export const fetchAllMessages = async (chatId: string): Promise<WPTChatMessage[]> => {
  const db = getDatabase();
  const conversationsRef = db.collection("conversations");
  const conversationRef = conversationsRef.doc(chatId);

  const snapshot = await conversationRef.collection("messages").get();

  if (snapshot.empty) {
    return [];
  }

  return snapshot.docs.map(doc => doc.data() as WPTChatMessage);
};

export const fetchChatHistory = async (userUid: string): Promise<ChatEntity[]> => {
  return chatRepository.findBy({ userUid });
};

export const deleteChatHistory = async (userUid: string): Promise<void> => {
  const chatEntities = await fetchChatHistory(userUid);

  const db = getDatabase();
  const conversationsRef = db.collection("conversations");

  const chatIds = chatEntities.map(chatEntity => chatEntity.chatId);

  const batch = db.batch();

  chatIds.forEach(chatId => {
    const conversationRef = conversationsRef.doc(chatId);
    batch.delete(conversationRef);
  });

  await batch.commit();

  await chatRepository.delete({ userUid });
};

export const updateChatName = async (userUid: string, chatId: string, name: string): Promise<void> => {
  const chatEntity = await fetchAndUpdateChatEntity(userUid, chatId);

  chatEntity.name = name;
  await chatRepository.save(chatEntity);
};

export const getChatName = async (userUid: string, chatId: string): Promise<string> => {
  const chatEntity = await fetchAndUpdateChatEntity(userUid, chatId);

  return chatEntity.name;
};