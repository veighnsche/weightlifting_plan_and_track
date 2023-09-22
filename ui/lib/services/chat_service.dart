import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/chat_model.dart';
import 'api_service.dart';

class ChatService {
  final ApiService _apiService = ApiService();
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

  Future<void> sendMessage(String? chatId, String message, List<WPTChatMessage> messages, Function(String chatId) updateChatId) async {
    try {
      final response = await _apiService.post(
        'http://localhost:3000/chat',
        {
          'chatId': chatId,
          'message': message,
          'messages': messages.map((message) => message.toMap()).toList(),
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data.containsKey('chatId')) {
          updateChatId(data['chatId']);
        }
        return;
      } else if (response.statusCode == 204) {
        return;
      } else {
        throw Exception('Failed to send message');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
  }

  Future<List<WPTChatConversation>> fetchHistory() async {
    try {
      final response = await _apiService.get('http://localhost:3000/chat/history');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        return WPTChatConversation.fromMapList(data['history']);
      } else {
        throw Exception('Failed to fetch chat history');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return [];
    }
  }

  Future<bool> deleteHistory() async {
    try {
      final response = await _apiService.delete('http://localhost:3000/chat/history');

      if (response.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete chat history');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return false;
    }
  }

  Future<String> fetchChatName(String chatId) async {
    try {
      final response = await _apiService.get('http://localhost:3000/chat/$chatId/name');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        return data['name'];
      } else {
        throw Exception('Failed to fetch chat name');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      return '';
    }
  }
}
