import 'package:flutter/material.dart';

import '../services/user_details_service.dart';
import '../widgets/user_details_form.dart';

class UserDetailsEditScreen extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const UserDetailsEditScreen({super.key, required this.userDetails});

  @override
  _UserDetailsEditScreenState createState() => _UserDetailsEditScreenState();
}

class _UserDetailsEditScreenState extends State<UserDetailsEditScreen> {
  final UserDetailsService _userService = UserDetailsService();

  void handleSubmit(Map<String, dynamic> updatedDetails) async {
    await _userService.upsert(updatedDetails);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userDetails = widget.userDetails['user'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit user details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: UserDetailsForm(
          onSubmit: handleSubmit,
          initialGender: userDetails['gender'],
          initialDateOfBirth: DateTime.parse(userDetails['dateOfBirth']),
          initialWeight: userDetails['weight'].toString(),
          initialHeight: userDetails['height'].toString(),
          initialFatPercentage: userDetails['fatPercentage'].toString(),
          initialGymDescription: userDetails['gymDescription'],
        ),
      ),
    );
  }
}
