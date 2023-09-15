import 'package:flutter/material.dart';

import '../services/socket_service.dart';

class SocketConnectionStream extends StatefulWidget {
  final VoidCallback handleDone;

  const SocketConnectionStream({super.key, required this.handleDone});

  @override
  _SocketConnectionStreamState createState() => _SocketConnectionStreamState();
}

class _SocketConnectionStreamState extends State<SocketConnectionStream> {
  late final SocketService _socketService;

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
    _socketService.connect();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _socketService.connectionState,
      builder: (context, snapshot) {
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

        if (snapshot.hasData && snapshot.data == true) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            widget.handleDone();
          });
          return const SizedBox.shrink();
        }

        return const CircularProgressIndicator();
      },
    );
  }
}
