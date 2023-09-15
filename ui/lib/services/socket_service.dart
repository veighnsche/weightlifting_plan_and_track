import 'dart:async';
import 'package:socket_io_client/socket_io_client.dart';
import 'auth_service.dart';

class SocketService {
  SocketService._privateConstructor();

  static final SocketService _instance = SocketService._privateConstructor();

  factory SocketService() {
    return _instance;
  }

  Socket? _socket;
  final AuthService _authService = AuthService();

  final _connectionStateController = StreamController<bool>.broadcast();
  Stream<bool> get connectionState => _connectionStateController.stream;

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
        _connectionStateController.add(true);
      })
      ..onDisconnect((_) {
        _connectionStateController.add(false);
      });
  }

  void disconnect() {
    _socket?.disconnect();
  }

  get emit => _socket?.emit;

  get emitWithAck => _socket?.emitWithAck;

  get on => _socket?.on;
}
