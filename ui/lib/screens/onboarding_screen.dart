import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/socket_emitters.dart';
import '../widgets/user_details_form.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final SocketEmitters _socketEmitter;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _socketEmitter = SocketEmitters();
  }

  void _handleUpsertResponse(Map<String, dynamic> response) {
    if (response['error'] != null) {
      _scaffoldMessengerKey.currentState?.showSnackBar(
        SnackBar(
          content: Text("Error during upsert: ${response['error']}"),
          backgroundColor: Colors.red,
        ),
      );
    } else if (mounted) {
      Navigator.pushReplacementNamed(context, '/chat');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? "User";
    final photoUrl = user?.photoURL;

    return Scaffold(
      key: _scaffoldMessengerKey,
      appBar: AppBar(
        title: const Text("Onboarding"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (photoUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                radius: 40,
              ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: UserDetailsForm(onSubmit: (userData) {
              _scaffoldMessengerKey.currentState?.showSnackBar(
                const SnackBar(
                  content: Text("Updating your details..."),
                  duration: Duration(seconds: 2),
                ),
              );
              _socketEmitter.upsertUser(
                userData,
                _handleUpsertResponse,
              );
            })),
          ],
        ),
      ),
    );
  }
}
