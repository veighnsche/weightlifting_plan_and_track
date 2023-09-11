import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'auth_service.dart';

class SocketService {
  IO.Socket? _socket;
  final AuthService _authService = AuthService();

  Future<void> connect() async {
    var token = await _authService.token;

    _socket = IO.io(
        'http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).setAuth({
          'token': token,
        }).build())
      ..onConnect((_) {
        if (kDebugMode) {
          print('Connected to Socket.io server');
        }
      })
      ..onDisconnect((_) {
        if (kDebugMode) {
          print('Disconnected from Socket.io server');
        }
      });
  }

  void disconnect() {
    _socket?.disconnect();
  }
}
