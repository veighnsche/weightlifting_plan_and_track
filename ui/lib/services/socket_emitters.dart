import 'socket_service.dart';

class SocketEmitters {
  final SocketService _socketService = SocketService();

  void newUserMessage(String content) {
    _socketService.emit('new-user-message', {
      'content': content,
    });
  }

  void upsertUser(Map<String, dynamic> details) {
    _socketService.emit('upsert-user', details);
  }
}
