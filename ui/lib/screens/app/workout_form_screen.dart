import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/services/app/workout_service.dart';

import '../../models/app/workout_model.dart';
import '../../widgets/app/workout_form.dart';

class AppWorkoutFormScreen extends StatefulWidget {
  const AppWorkoutFormScreen({super.key});

  @override
  _AppWorkoutFormScreenState createState() => _AppWorkoutFormScreenState();
}

class _AppWorkoutFormScreenState extends State<AppWorkoutFormScreen> {
  final AppWorkoutService _appWorkoutService = AppWorkoutService();

  void _onFormSubmit(AppWorkoutModel workout) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pop(workout);
    });
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
          child: AppWorkoutForm(
            onFormSubmit: _onFormSubmit,
            appWorkoutService: _appWorkoutService,
          ),
        ),
      ),
    );
  }
}
