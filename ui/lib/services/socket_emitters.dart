import 'socket_service.dart';

class SocketEmitters {
  final SocketService _socketService = SocketService();

  void newUserMessage(String content) {
    _socketService.emit('new-user-message', {
      'content': content,
    });
  }

  void checkOnboarding(Function(Map<String, dynamic>) ackCallback) {
    _socketService.emitWithAck('check-onboarding', {}, ack: ackCallback);
  }

  void upsertUser(Map<String, dynamic> details, Function(Map<String, dynamic>) ackCallback) {
    _socketService.emitWithAck('upsert-user', details, ack: ackCallback);
  }
}
