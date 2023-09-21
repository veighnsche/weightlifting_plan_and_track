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
  parameters?: Record<string, any> & { content: string, callback?: string };
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
    content
  };

  await saveMessageToFirestore(conversationRef.id, wptChatMessage);

  return conversationRef.id;
};

export const addMessage = async (params: BaseMessageParams): Promise<void> => {
  if (!params.userUid || !params.chatId || !params.content) {
    throw new Error("Invalid parameters provided.");
  }

  const chatEntity = await fetchAndUpdateChatEntity(params.userUid, params.chatId);

  const wptChatMessage: WPTChatMessage = {
    role: params.role ?? WPTMessageRole.User,
    content: params.content
  };

  if (params.role === WPTMessageRole.Assistant && params.functionName && params.parameters) {
    wptChatMessage.functionCall = {
      functionName: params.functionName,
      parameters: params.parameters,
      status: WPTFunctionStatus.Pending
    };

    if (params.parameters.callback) {
      wptChatMessage.functionCall.callback = params.parameters.callback;
    }
  }

  await saveMessageToFirestore(chatEntity.chatId, wptChatMessage);
};
