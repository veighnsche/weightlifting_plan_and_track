import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference _getMessagesRef(String chatId) {
    return _firestore
        .collection('conversations')
        .doc(chatId)
        .collection('messages');
  }

  Stream<List<WPTChatMessage>> getMessagesStream(String? chatId) {
    if (chatId == null) return Stream.value([]);

    return _getMessagesRef(chatId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return WPTChatMessage.fromMap(doc.id, data);
      }).toList();
    });
  }

}
