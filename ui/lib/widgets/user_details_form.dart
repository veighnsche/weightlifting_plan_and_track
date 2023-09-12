import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/widgets/custom_date_picker.dart';

import '../themes/input_decorations.dart';

class UserDetailsForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;

  const UserDetailsForm({super.key, required this.onSubmit});

  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  String? gender;
  DateTime? dateOfBirth; // New dateOfBirth field
  String? weight;
  String? height;
  String? fatPercentage;
  String? gymDescription;

  void handlePressed() {
    _formKey.currentState!.save();

    widget.onSubmit({
      'user': {
        'gender': gender,
        'dateOfBirth': dateOfBirth?.toIso8601String(), // Save as ISO string
        'weight': weight,
        'height': height,
        'fatPercentage': fatPercentage,
        'gymDescription': gymDescription,
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                TextFormField(
                  decoration:
                      blueInputDecoration(label: "Gender", icon: Icons.person),
                  onSaved: (value) => gender = value,
                ),
                const SizedBox(height: 16),
                CustomDatePicker(
                    initialDate: dateOfBirth,
                    onDateChanged: (date) {
                      setState(() {
                        dateOfBirth = date;
                      });
                    }),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: blueInputDecoration(
                      label: "Weight (kg)", icon: Icons.fitness_center),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => weight = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: blueInputDecoration(
                      label: "Height (cm)", icon: Icons.height),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => height = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: blueInputDecoration(
                      label: "Fat Percentage (%)", icon: Icons.pie_chart),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => fatPercentage = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: blueInputDecoration(
                      label: "Gym Description", icon: Icons.description),
                  maxLines: 3,
                  onSaved: (value) => gymDescription = value,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: handlePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
