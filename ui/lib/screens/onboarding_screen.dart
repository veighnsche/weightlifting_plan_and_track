import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/socket_service.dart';
import '../widgets/user_details_form.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final SocketService _socketService = SocketService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final name = user?.displayName ?? "User";
    final photoUrl = user?.photoURL;

    return Scaffold(
      appBar: AppBar(title: const Text("Onboarding")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (photoUrl != null)
              CircleAvatar(
                backgroundImage: NetworkImage(photoUrl),
                radius: 40, // Adjust the size as needed
              ),
            const SizedBox(height: 10),
            Text(name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: UserDetailsForm(
                onSubmit: (userData) {
                  _socketService.upsertUser(userData);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
