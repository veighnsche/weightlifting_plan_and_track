import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthStateStream extends StatefulWidget {
  final Widget child;

  const AuthStateStream({Key? key, required this.child}) : super(key: key);

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
            Future.microtask(
                () => Navigator.pushReplacementNamed(context, '/login'));
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16), // Add some spacing
                  Text(
                    "Checking authentication status...",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          } else {
            return widget.child;
          }
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
