import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AppSpeedDial extends StatelessWidget {
  const AppSpeedDial({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Colors.blueGrey,
      icon: Icons.add,
      activeIcon: Icons.close,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.directions_run),
          backgroundColor: Colors.blueGrey,
          label: 'Add Workout',
          onTap: () {
            Navigator.pushNamed(context, '/app/workouts/add');
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.fitness_center),
          backgroundColor: Colors.blueGrey,
          label: 'Add Exercise',
          onTap: () {
            // Handle the "Add Exercise" action
          },
        ),
        // add set speed dial child
        SpeedDialChild(
          child: const Icon(Icons.check),
          backgroundColor: Colors.blueGrey,
          label: 'Add Completed Set',
          onTap: () {
            // Handle the "Add Set" action
          },
        ),
      ],
    );
  }
}
