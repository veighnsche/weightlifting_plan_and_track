import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'auth_service.dart';

class SocketService {
  SocketService._privateConstructor();

  static final SocketService _instance = SocketService._privateConstructor();

  factory SocketService() {
    return _instance;
  }

  IO.Socket? _socket;
  final AuthService _authService = AuthService();

  final _connectionStateController = StreamController<bool>.broadcast();

  Stream<bool> get connectionState => _connectionStateController.stream;

  Future<void> connect([bool? forceReconnect]) async {
    if ((_socket?.connected ?? false) && forceReconnect != true) {
      return;
    }

    if (_socket != null) {
      _socket?.disconnect();
    }

    var token = await _authService.token;

    _socket = IO.io(
        'http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).setAuth({
          'token': token,
        }).build())
      ..onConnect((_) {
        _connectionStateController.add(true);
      })
      ..onDisconnect((_) {
        _connectionStateController.add(false);
      })
      ..onConnectError((_) {
        _connectionStateController.add(false);
      })
      ..on('token-expired', (_) {
        connect(true);
      });
  }

  void disconnect() {
    _socket?.disconnect();
  }

  get emit => _socket?.emit;

  get emitWithAck => _socket?.emitWithAck;

  get on => _socket?.on;
}
