import 'package:flutter/material.dart';

import '../../models/app/screen_models/scr1_workout_list.dart';

class Scr1Grid extends StatelessWidget {
  final Scr1WorkoutList workout;

  const Scr1Grid({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 4 / 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: workout.workouts.length,
      itemBuilder: (context, index) {
        return Scr1ItemBox(workout: workout.workouts[index]);
      },
    );
  }
}

class Scr1ItemBox extends StatelessWidget {
  final Scr1WorkoutItem workout;

  const Scr1ItemBox({Key? key, required this.workout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle tap if needed
      },
      borderRadius: BorderRadius.circular(4),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white, // Background color
          boxShadow: [
            // Adding a shadow similar to Card's elevation
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.all(2.0), // Further reduced padding
          child: Text(
            workout.name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }
}
