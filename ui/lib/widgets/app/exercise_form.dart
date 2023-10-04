import 'package:flutter/material.dart';

import '../../services/app/exercise_service.dart';
import '../../themes/input_decorations.dart';

class AppExerciseForm extends StatefulWidget {
  final Function(bool ok) onSubmitted;
  final AppExerciseService appExerciseService;

  const AppExerciseForm({
    super.key,
    required this.onSubmitted,
    required this.appExerciseService,
  });

  @override
  _AppExerciseFormState createState() => _AppExerciseFormState();
}

class _AppExerciseFormState extends State<AppExerciseForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  void _submitForm() async {
    final Map<String, dynamic> data = {
      'name': _nameController.text,
      'note': _noteController.text,
    };

    final bool ok = await widget.appExerciseService.upsert(data);

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
        // Note
        TextFormField(
          controller: _noteController,
          decoration: BlueInputDecoration(labelText: "Note"),
          maxLines: 5,
        ),
        const SizedBox(height: 16.0),
        // Submit button
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
