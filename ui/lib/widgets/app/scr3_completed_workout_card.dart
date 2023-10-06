import 'package:flutter/material.dart';

import '../../models/app/screen_models/workout_details.dart';

class Scr3CompletedWorkoutCard extends StatelessWidget {
  final Scr3CompletedWorkout completedWorkout;

  const Scr3CompletedWorkoutCard({
    super.key,
    required this.completedWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              completedWorkout.startedAt,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (completedWorkout.note != null)
              Text(
                completedWorkout.note!,
                style: const TextStyle(fontStyle: FontStyle.italic),
              ),
            if (completedWorkout.isActive)
              const Icon(Icons.check_circle, color: Colors.green),
            Text('Completed Reps: ${completedWorkout.completedRepsAmount}'),
          ],
        ),
      ),
    );
  }
}
