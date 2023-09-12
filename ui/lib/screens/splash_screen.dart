import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/socket_listeners.dart';
import '../services/socket_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Weightlifting Plan and Track',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            AuthStateStream(),
          ],
        ),
      ),
    );
  }
}

class AuthStateStream extends StatefulWidget {
  AuthStateStream({super.key});

  @override
  _AuthStateStreamState createState() => _AuthStateStreamState();
}

class _AuthStateStreamState extends State<AuthStateStream> {
  final SocketService _socketService = SocketService();
  final SocketListeners _socketListeners = SocketListeners();

  @override
  void initState() {
    super.initState();
    _initializeSocketConnection();
  }

  Future<void> _initializeSocketConnection() async {
    await _socketService.connect();
    _setupSocketListeners();
  }

  void _setupSocketListeners() {
    _socketListeners.onUserConnected((data) {
      if (data['onboarded'] == false) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      } else {
        Navigator.pushReplacementNamed(context, '/chat');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/login');
            });
            return const SizedBox.shrink();
          } else {
            return FutureBuilder<void>(
              future: _socketService.connect(),
              builder: (context, socketSnapshot) {
                if (socketSnapshot.connectionState == ConnectionState.done) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, '/chat');
                  });
                  return const SizedBox.shrink();
                }
                return const CircularProgressIndicator();
              },
            );
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
