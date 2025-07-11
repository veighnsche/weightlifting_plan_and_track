import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/services/app/workout_service.dart';

import '../../widgets/app/workout_form.dart';

class AppWorkoutFormScreen extends StatefulWidget {
  final String? initialName;
  final int? initialDayOfWeek;
  final String? initialNote;

  const AppWorkoutFormScreen({
    super.key,
    this.initialName,
    this.initialDayOfWeek,
    this.initialNote,
  });

  @override
  _AppWorkoutFormScreenState createState() => _AppWorkoutFormScreenState();
}

class _AppWorkoutFormScreenState extends State<AppWorkoutFormScreen> {
  final AppWorkoutService _appWorkoutService = AppWorkoutService();

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
        title: const Text('Workout Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Material(
          child: AppWorkoutForm(
            onSubmitted: _onSubmitted,
            appWorkoutService: _appWorkoutService,
            initialName: widget.initialName,
            initialDayOfWeek: widget.initialDayOfWeek,
            initialNote: widget.initialNote,
          ),
        ),
      ),
    );
  }
}
