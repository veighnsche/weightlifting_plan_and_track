import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateStream extends StatefulWidget {
  final VoidCallback handleDone;

  const AuthStateStream({Key? key, required this.handleDone}) : super(key: key);

  @override
  _AuthStateStreamState createState() => _AuthStateStreamState();
}

class _AuthStateStreamState extends State<AuthStateStream> {
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    "Checking authentication status...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.handleDone();
            });
            return const SizedBox.shrink();
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
