import 'package:flutter/material.dart';

import '../../themes/input_decorations.dart';

class AppWorkoutFormScreen extends StatefulWidget {
  const AppWorkoutFormScreen({super.key});

  @override
  _AppWorkoutFormScreenState createState() => _AppWorkoutFormScreenState();
}

class _AppWorkoutFormScreenState extends State<AppWorkoutFormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final List<String> _daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          child: ListView(
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: blueInputDecoration(label: "Name"),
              ),
              const SizedBox(height: 16.0),

              // Day of Week Dropdown
              DropdownButtonFormField<String>(
                value: _selectedDay,
                decoration: blueInputDecoration(label: "Day of the Week"),
                items: _daysOfWeek.map((String day) {
                  return DropdownMenuItem<String>(
                    value: day,
                    child: Text(day),
                  );
                }).toList(),
                onChanged: (String? value) {
                  setState(() {
                    _selectedDay = value;
                  });
                },
              ),
              const SizedBox(height: 16.0),

              // Note
              TextFormField(
                controller: _noteController,
                decoration: blueInputDecoration(label: "Note"),
                maxLines: 5,
              ),
              const SizedBox(height: 16.0),

              // ... your other form fields ...

              ElevatedButton(
                onPressed: _submitForm,
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    // TODO: Handle the form submission
    // For instance, you can create an AppWorkoutModel object from the inputs.
    // AppWorkoutModel model = AppWorkoutModel(
    //   workoutId: SOME_GENERATED_ID,  // Generate or fetch an ID as needed
    //   name: _nameController.text,
    //   dayOfWeek: _daysOfWeek.indexOf(_selectedDay),  // Convert day string to int
    //   note: _noteController.text,
    //   exercises: [],  // Handle exercises list as needed
    // );
  }
}
