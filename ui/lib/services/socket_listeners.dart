import 'socket_service.dart';

class SocketListeners {
  final SocketService _socketService = SocketService();

  void onNewSystemMessage(Function(Map<String, dynamic>) callback) {
    _socketService.on('new-system-message', (data) {
      callback(data);
    });
  }

  void onNewAssistantMessage(Function(Map<String, dynamic>) callback) {
    _socketService.on('new-assistant-message', (data) {
      callback(data);
    });
  }
}
