import 'package:flutter/material.dart';

import '../../models/app/screen_models/scr4_exercise_details.dart';

class Scr4CompletedWorkoutCard extends StatelessWidget {
  final Scr4CompletedWorkout completedWorkout;

  const Scr4CompletedWorkoutCard({Key? key, required this.completedWorkout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(completedWorkout.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Started At: ${completedWorkout.startedAt}"),
            Text("Max Reps: ${completedWorkout.maxReps}"),
            Text("Min Weight: ${completedWorkout.minWeight}"),
            Text("Max Weight: ${completedWorkout.maxWeight}"),
            Text("Avg Rest Time: ${completedWorkout.avgRestTimeBefore}"),
            Text("Total Volume: ${completedWorkout.totalVolume}"),
          ],
        ),
      ),
    );
  }
}
