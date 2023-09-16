import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get _messagesRef => _firestore.collection('conversations').doc('MkgFHF6GnFSC9emhKrRh').collection('messages');

  Stream<List<WPTChatMessage>> getMessagesStream() {
    return _messagesRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        // return WPTChatMessage(
        //   messageID: doc.id,
        //   role: WPTMessageRole.values.firstWhere((e) => e.toString() == 'WPTMessageRole.${data['role']}'),
        //   content: data['content'],
        // );
        return WPTChatMessage.fromMap(doc.id, data);
      }).toList();
    });
  }
}
