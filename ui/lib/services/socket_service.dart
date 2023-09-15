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

  final _errorController = StreamController<String?>.broadcast();
  Stream<String?> get errors => _errorController.stream;

  static const int _maxRetryAttempts = 5;
  static const Duration _initialRetryDelay = Duration(seconds: 2);

  Future<void> connect() async {
    if (_socket?.connected ?? false) {
      return;
    }

    var token = await _authService.token;
    int retryCount = 0;
    Duration retryDelay = _initialRetryDelay;
    bool isConnected = false;

    while (retryCount < _maxRetryAttempts && !isConnected) {
      try {
        _socket = io(
            'http://localhost:3000',
            OptionBuilder().setTransports(['websocket']).setAuth({
              'token': token,
            }).build())
          ..onConnect((_) {
            _connectionStateController.add(true);
            isConnected = true; // Update the connection status
            clearError(); // Clear any previous errors
          })
          ..onDisconnect((_) {
            _connectionStateController.add(false);
          })
          ..onError((errorData) {
            // Handle the error data here
            _errorController.add("Failed to connect to the server: $errorData");
          });

        if (!isConnected) {
          await Future.delayed(retryDelay);  // Wait before trying again
          retryCount++;
          retryDelay *= 2;  // Double the delay for each retry
        }
      } catch (e) {
        if (retryCount >= _maxRetryAttempts) {
          _errorController.add("Max retry attempts reached. Unable to connect.");
        }
      }
    }
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void clearError() {
    _errorController.add(null);
  }

  get emit => _socket?.emit;

  get emitWithAck => _socket?.emitWithAck;

  get on => _socket?.on;
}
