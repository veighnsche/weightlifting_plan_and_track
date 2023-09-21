import { dataSource } from "../../services/database";
import { getDatabase } from "../../services/firebase";
import { WPTChatMessage, WPTFunctionStatus, WPTMessageRole } from "./chatDocument";
import { ChatEntity } from "./chatEntity";

interface BaseMessageParams {
  userUid: string;
  chatId?: string;
  content: string;
  role?: WPTMessageRole;
  functionName?: string;
  args?: Record<string, any>;
  callback?: string;
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

export const newChat = async ({ userUid, content }: BaseMessageParams): Promise<string> => {
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
    content,
  };

  await saveMessageToFirestore(conversationRef.id, wptChatMessage);

  return conversationRef.id;
};

export const addMessage = async ({
  chatId,
  content,
  functionName,
  args,
  callback,
  role,
  userUid,
}: BaseMessageParams): Promise<void> => {
  if (!userUid || !chatId || !content) {
    throw new Error(`Invalid parameters provided. userUid: ${userUid}, chatId: ${chatId}, content: ${content}`);
  }

  const chatEntity = await fetchAndUpdateChatEntity(userUid, chatId);

  const wptChatMessage: WPTChatMessage = {
    role: role ?? WPTMessageRole.User,
    content: content,
  };

  if (role === WPTMessageRole.Assistant && functionName && args) {
    wptChatMessage.functionCall = {
      functionName,
      args: JSON.stringify(args),
      status: WPTFunctionStatus.Pending,
    };

    if (callback) {
      wptChatMessage.functionCall.callback = callback;
    }
  }

  await saveMessageToFirestore(chatEntity.chatId, wptChatMessage);
};

/**
 * Fetch all messages from Firestore for a given chat.
 *
 * @param chatId The ID of the chat (conversation) whose messages need to be fetched.
 * @returns An array of WPTChatMessage.
 */
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
