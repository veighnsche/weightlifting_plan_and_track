import 'dart:async';

import 'package:flutter/material.dart';

import '../services/socket_service.dart';

class SocketConnectionStream extends StatefulWidget {
  final Widget child;

  const SocketConnectionStream({super.key, required this.child});

  @override
  _SocketConnectionStreamState createState() => _SocketConnectionStreamState();
}

class _SocketConnectionStreamState extends State<SocketConnectionStream> {
  late final SocketService _socketService;
  String? _errorMessage;
  StreamSubscription? _errorSubscription; // Reference to the StreamSubscription

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
    _socketService.connect();

    _errorSubscription = _socketService.errors.listen((errorMsg) {
      if (mounted) {
        setState(() {
          _errorMessage = errorMsg;
        });
      }
    });
  }

  @override
  void dispose() {
    _errorSubscription?.cancel(); // Cancel the StreamSubscription
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _socketService.connectionState,
      builder: (context, snapshot) {
        if (_errorMessage != null) {
          return Center(child: Text(_errorMessage!));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the connection state, display a loading indicator
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16), // Add some spacing
                Text(
                  "Connecting to server...",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          );
        }

        print(snapshot.data);

        if (snapshot.hasData && snapshot.data == true) {
          return widget.child;
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
