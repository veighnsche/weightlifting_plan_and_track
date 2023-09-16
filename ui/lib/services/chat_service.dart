// import 'package:firebase_database/firebase_database.dart';
import '../models/chat_model.dart';

class ChatService {
  // final FirebaseDatabase _database = FirebaseDatabase.instance;
  // DatabaseReference get _ref => _database.ref();
  //
  // Stream<List<WPTChatMessage>> getMessagesStream() {
  //   DatabaseReference messagesRef = _database.ref('/conversations/conversation67890/messages');
  //
  //   return messagesRef.onValue.map((event) {
  //     print("event.snapshot.value ${event.snapshot.value}");
  //
  //     Map<dynamic, dynamic>? map = event.snapshot.value as Map<dynamic, dynamic>?;
  //     List<WPTChatMessage> messages = [];
  //
  //     map?.forEach((key, value) {
  //       messages.add(WPTChatMessage(
  //         messageID: key,
  //         role: WPTMessageRole.values.firstWhere((e) => e.toString() == 'WPTMessageRole.${value['role']}'),
  //         content: value['content'],
  //         timestamp: value['timestamp'],
  //       ));
  //     });
  //
  //     return messages;
  //   });
  // }
  //
  // Future<List<WPTChatMessage>> getMessages() {
  //   DatabaseReference messagesRef = _ref.child('/conversations/conversation67890/messages');
  //
  //   return messagesRef.get().then((DataSnapshot snapshot) {
  //     print("snapshot.value ${snapshot.value}");
  //
  //     Map<dynamic, dynamic>? map = snapshot.value as Map<dynamic, dynamic>?;
  //     List<WPTChatMessage> messages = [];
  //
  //     map?.forEach((key, value) {
  //       messages.add(WPTChatMessage(
  //         messageID: key,
  //         role: WPTMessageRole.values.firstWhere((e) => e.toString() == 'WPTMessageRole.${value['role']}'),
  //         content: value['content'],
  //         timestamp: value['timestamp'],
  //       ));
  //     });
  //
  //     return messages;
  //   });
  // }

  Future<List<WPTChatMessage>> getMessages() {
    return Future.delayed(const Duration(seconds: 1), () {
      return [
        WPTChatMessage(
          messageID: 'message12345',
          role: WPTMessageRole.user,
          content: 'Hello, how are you?',
        ),
        WPTChatMessage(
          messageID: 'message67890',
          role: WPTMessageRole.assistant,
          content: 'I am fine, thank you.',
        ),
        WPTChatMessage(
          messageID: 'message23456',
          role: WPTMessageRole.system,
          content: 'How can I help you?',
        ),
      ];
    });
  }
}
