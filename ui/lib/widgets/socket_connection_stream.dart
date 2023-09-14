import 'package:flutter/material.dart';
import '../services/socket_emitters.dart';
import '../services/socket_service.dart';

class SocketConnectionStream extends StatefulWidget {
  const SocketConnectionStream({Key? key}) : super(key: key);

  @override
  _SocketConnectionStreamState createState() => _SocketConnectionStreamState();
}

class _SocketConnectionStreamState extends State<SocketConnectionStream> {
  late final SocketService _socketService;
  late final SocketEmitters _socketEmitters;

  @override
  void initState() {
    super.initState();
    _socketService = SocketService();
    _socketService.connect().then((_) {
      _socketEmitters = SocketEmitters();
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _socketService.connectionState,
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          _socketEmitters.checkOnboarding((data) {
            if (mounted) {
              if (data['onboarded'] == false) {
                Navigator.pushReplacementNamed(context, '/onboarding');
              } else {
                Navigator.pushReplacementNamed(context, '/chat');
              }
            }
          });
          return const SizedBox.shrink();
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
