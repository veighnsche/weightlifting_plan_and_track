import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart';

import 'auth_service.dart';

class SocketService {
  SocketService._privateConstructor();

  static final SocketService _instance = SocketService._privateConstructor();

  factory SocketService() {
    return _instance;
  }

  Function? onUserConnect;

  Socket? _socket;
  final AuthService _authService = AuthService();

  Future<void> connect() async {
    if (_socket?.connected ?? false) {
      return;
    }

    var token = await _authService.token;

    _socket = io(
        'http://localhost:3000',
        OptionBuilder().setTransports(['websocket']).setAuth({
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

  get emit => _socket?.emit;

  get on => _socket?.on;
}
