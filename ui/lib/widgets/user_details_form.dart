import 'package:flutter/material.dart';

import '../themes/input_decorations.dart';
import 'custom_date_picker.dart';

class UserDetailsForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final String? initialGender;
  final DateTime? initialDateOfBirth;
  final String? initialWeight;
  final String? initialHeight;
  final String? initialFatPercentage;
  final String? initialGymDescription;

  const UserDetailsForm({
    super.key,
    required this.onSubmit,
    this.initialGender,
    this.initialDateOfBirth,
    this.initialWeight,
    this.initialHeight,
    this.initialFatPercentage,
    this.initialGymDescription,
  });

  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  late String? gender;
  late DateTime? dateOfBirth;
  late String? weight;
  late String? height;
  late String? fatPercentage;
  late String? gymDescription;

  @override
  void initState() {
    super.initState();
    gender = widget.initialGender;
    dateOfBirth = widget.initialDateOfBirth;
    weight = widget.initialWeight;
    height = widget.initialHeight;
    fatPercentage = widget.initialFatPercentage;
    gymDescription = widget.initialGymDescription;
  }

  void handlePressed() {
    _formKey.currentState!.save();

    widget.onSubmit({
      'user': {
        'gender': gender == '' ? null : gender,
        'dateOfBirth': dateOfBirth?.toIso8601String(),
        'weight': weight == '' ? null : double.parse(weight!),
        'height': height == '' ? null : double.parse(height!),
        'fatPercentage': fatPercentage == '' ? null : double.parse(fatPercentage!),
        'gymDescription': gymDescription == '' ? null : gymDescription,
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
                  initialValue: gender,
                  decoration:
                      BlueInputDecoration(labelText: "Gender", customIcon: Icons.person),
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
                  initialValue: weight,
                  decoration: BlueInputDecoration(
                      labelText: "Weight (kg)", customIcon: Icons.fitness_center),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => weight = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: height,
                  decoration: BlueInputDecoration(
                      labelText: "Height (cm)", customIcon: Icons.height),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => height = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: fatPercentage,
                  decoration: BlueInputDecoration(
                      labelText: "Fat Percentage (%)", customIcon: Icons.pie_chart),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => fatPercentage = value,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: gymDescription,
                  decoration: BlueInputDecoration(
                      labelText: "Gym Description", customIcon: Icons.description),
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
                backgroundColor: Colors.blueGrey,
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
