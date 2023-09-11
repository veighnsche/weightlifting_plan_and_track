import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/chat.dart';
import 'services/auth_service.dart';
import 'services/socket_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService _authService = AuthService();

  final SocketService _socketService = SocketService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            User? user = snapshot.data;
            if (user == null) {
              _socketService.disconnect();
              return LoginScreen(authService: _authService);
            } else {
              return FutureBuilder<void>(
                future: _socketService.connect(),
                builder: (context, socketSnapshot) {
                  if (socketSnapshot.connectionState == ConnectionState.done) {
                    return ChatScreen(socketService: _socketService);
                  }
                  return const CircularProgressIndicator(); // Show a loader while connecting
                },
              );
            }
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }

  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }
}

class LoginScreen extends StatelessWidget {
  final AuthService authService;

  LoginScreen({required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: const Text('Sign in with Google'),
          onPressed: () async {
            await authService.signInWithGoogle();
          },
        ),
      ),
    );
  }
}
