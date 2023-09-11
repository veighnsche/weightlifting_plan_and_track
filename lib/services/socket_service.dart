import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket? _socket;

  void connect() {
    _socket = IO.io('http://localhost:3000',
        IO.OptionBuilder().setTransports(['websocket']).build())
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
