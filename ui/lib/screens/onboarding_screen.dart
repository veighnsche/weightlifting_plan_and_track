import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/socket_service.dart';
import '../widgets/user_details_form.dart';

class OnboardingScreen extends StatefulWidget {
  final SocketService socketService;

  const OnboardingScreen({super.key, required this.socketService});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final name = FirebaseAuth.instance.currentUser?.displayName ?? "User";

    return Scaffold(
      appBar: AppBar(title: const Text("Onboarding")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: UserDetailsForm(
                onSubmit: (userData) {
                  widget.socketService.upsertUser(userData);
                },
                name: name,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
