import 'socket_service.dart';

class SocketListeners {
  final SocketService _socketService = SocketService();

  void onUserConnected(Function callback) {
    _socketService.on('user-connected', (data) {
      callback(data);
    });
  }
}
