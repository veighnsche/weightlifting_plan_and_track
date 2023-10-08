import 'package:flutter/material.dart';

import '../../models/app/screen_models/scr4_exercise_details.dart';

class Scr4WorkoutCard extends StatelessWidget {
  final Scr4Workout workout;

  const Scr4WorkoutCard({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(workout.name),
        subtitle: Text(workout.note ?? ""),
        trailing: Text("Day: ${workout.dayOfWeek}"),
      ),
    );
  }
}
