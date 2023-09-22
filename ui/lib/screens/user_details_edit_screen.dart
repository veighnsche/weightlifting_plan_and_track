import 'package:flutter/material.dart';

import '../services/user_details_service.dart';
import '../widgets/user_details_form.dart';

class UserDetailsEditScreen extends StatelessWidget {
  UserDetailsEditScreen({super.key});

  final UserDetailsService _userService = UserDetailsService();

  void handleSubmit(
      BuildContext context, Map<String, dynamic> updatedDetails) async {
    await _userService.upsert(updatedDetails);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit user details"),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userService.read(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(child: Text('An error occurred!'));
          } else if (!snapshot.hasData || !snapshot.data!.containsKey('user')) {
            return const Center(child: Text('No data found!'));
          } else {
            final userDetails = snapshot.data!['user'];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: UserDetailsForm(
                onSubmit: (updatedDetails) =>
                    handleSubmit(context, updatedDetails),
                initialGender: userDetails['gender'],
                initialDateOfBirth: DateTime.parse(userDetails['dateOfBirth']),
                initialWeight: userDetails['weight'].toString(),
                initialHeight: userDetails['height'].toString(),
                initialFatPercentage: userDetails['fatPercentage'].toString(),
                initialGymDescription: userDetails['gymDescription'],
              ),
            );
          }
        },
      ),
    );
  }
}
