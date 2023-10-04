import 'package:flutter/material.dart';

import '../../services/app/workout_service.dart';
import '../../themes/input_decorations.dart';

class AppWorkoutForm extends StatefulWidget {
  final Function(bool ok) onSubmitted;
  final AppWorkoutService appWorkoutService;

  const AppWorkoutForm({
    super.key,
    required this.onSubmitted,
    required this.appWorkoutService,
  });

  @override
  _AppWorkoutFormState createState() => _AppWorkoutFormState();
}

class _AppWorkoutFormState extends State<AppWorkoutForm> {
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
      'day_of_week':
          _selectedDay == null ? null : _daysOfWeek.indexOf(_selectedDay!) - 1,
      'note': _noteController.text,
    };

    final bool ok =
        await widget.appWorkoutService.upsert(data);

    if (ok) {
      widget.onSubmitted(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // Name
        TextFormField(
          controller: _nameController,
          decoration: BlueInputDecoration(labelText: "Name"),
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          value: _selectedDay,
          decoration: BlueInputDecoration(labelText: "Day of the Week"),
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
          decoration: BlueInputDecoration(labelText: "Note"),
          maxLines: 5,
        ),
        const SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
