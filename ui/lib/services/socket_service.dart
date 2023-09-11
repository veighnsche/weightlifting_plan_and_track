import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'auth_service.dart';

class SocketService {
  SocketService._privateConstructor();

  static final SocketService _instance = SocketService._privateConstructor();

  factory SocketService() {
    return _instance;
  }

  Function? onUserNotOnboarded;

  IO.Socket? _socket;
  final AuthService _authService = AuthService();

  Future<void> connect() async {
    if (_socket?.connected ?? false) {
      return;
    }

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
      })
      ..on('user-connected', (data) {
        if (data['onboarded'] == false) {
          onUserNotOnboarded?.call(false);
        } else {
          onUserNotOnboarded?.call(true);
        }

        _socket?.emit('acknowledge-user-connected');
      });
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void sendMessage(String content) {
    _socket?.emit('new-user-message', {
      'content': content,
    });
  }

  void upsertUser(Map<String, String> details) {
    _socket?.emit('upsert-user', details);
  }
}
