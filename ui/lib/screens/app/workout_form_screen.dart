import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/services/app/workout_service.dart';

import '../../models/app/workout_model.dart';
import '../../themes/input_decorations.dart';

class AppWorkoutFormScreen extends StatefulWidget {
  const AppWorkoutFormScreen({super.key});

  @override
  _AppWorkoutFormScreenState createState() => _AppWorkoutFormScreenState();
}

class _AppWorkoutFormScreenState extends State<AppWorkoutFormScreen> {
  final AppWorkoutService _appWorkoutService = AppWorkoutService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final List<String> _daysOfWeek = [
    'None',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  String? _selectedDay;

  void _submitForm() async {
    final Map<String, dynamic> data = {
      'name': _nameController.text,
      'dayOfWeek':
          _selectedDay == null ? null : _daysOfWeek.indexOf(_selectedDay!) - 1,
      'note': _noteController.text,
    };

    final AppWorkoutModel? workout = await _appWorkoutService.upsert(data);

    if (workout != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop(workout);
      });
    }
  }

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
                    _selectedDay = value == 'None' ? null : value;
                  });
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _noteController,
                decoration: blueInputDecoration(label: "Note"),
                maxLines: 5,
              ),
              const SizedBox(height: 16.0),
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
}
