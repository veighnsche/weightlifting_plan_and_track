import 'package:flutter/material.dart';

class UserDetailsForm extends StatefulWidget {
  final Function(Map<String, dynamic>) onSubmit;
  final String name;

  const UserDetailsForm({super.key, required this.onSubmit, required this.name});

  @override
  _UserDetailsFormState createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  String? gender;
  String? age;
  String? weight;
  String? height;
  String? fatPercentage;
  String? gymDescription;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Gender"),
                  onSaved: (value) => gender = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Age"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => age = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Weight (kg)"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => weight = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Height (cm)"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => height = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Fat Percentage (%)"),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => fatPercentage = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: "Gym Description"),
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
              onPressed: () {
                _formKey.currentState!.save();

                widget.onSubmit({
                  'gender': gender,
                  'age': age,
                  'weight': weight,
                  'height': height,
                  'fatPercentage': fatPercentage,
                  'gymDescription': gymDescription,
                });
              },
              style: ElevatedButton.styleFrom(
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
