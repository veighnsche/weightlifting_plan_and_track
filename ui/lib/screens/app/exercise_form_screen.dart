import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/services/app/exercise_service.dart';

import '../../widgets/app/exercise_form.dart';

class AppExerciseFormScreen extends StatefulWidget {
  const AppExerciseFormScreen({super.key});

  @override
  _AppExerciseFormScreenState createState() => _AppExerciseFormScreenState();
}

class _AppExerciseFormScreenState extends State<AppExerciseFormScreen> {
  final AppExerciseService _appExerciseService = AppExerciseService();

  void _onSubmitted(bool ok) {
    if (!ok) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop(ok);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          child: AppExerciseForm(
            onSubmitted: _onSubmitted,
            appExerciseService: _appExerciseService,
          ),
        ),
      ),
    );
  }
}
