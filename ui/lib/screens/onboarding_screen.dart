import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/socket_service.dart';

class OnboardingScreen extends StatefulWidget {
  final SocketService socketService;

  const OnboardingScreen({super.key, required this.socketService});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  String? age;
  String? weight;
  String? height;
  String? gymDescription;

  @override
  Widget build(BuildContext context) {
    // Fetch the name from Firebase Auth
    final name = FirebaseAuth.instance.currentUser?.displayName ?? "User";

    return Scaffold(
      appBar: AppBar(title: const Text("Onboarding")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text("Name: $name",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: "Age"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) => age = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Weight"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your weight';
                  }
                  return null;
                },
                onSaved: (value) => weight = value,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Height"),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your height';
                  }
                  return null;
                },
                onSaved: (value) => height = value,
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "Gym Description (Optional)"),
                maxLines: 3,
                onSaved: (value) => gymDescription = value,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    widget.socketService.upsertUser({
                      'age': age!,
                      'weight': weight!,
                      'height': height!,
                      'gymDescription': gymDescription!,
                    });
                  }
                },
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
