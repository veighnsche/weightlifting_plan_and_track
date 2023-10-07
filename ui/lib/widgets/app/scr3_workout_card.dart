import 'package:flutter/material.dart';

import '../../models/app/screen_models/scr3_workout_details.dart';
import '../../utils/scr3_utils.dart';
import '../detail_box.dart';
import 'scr3_exercise_card.dart';

class Scr3WorkoutCard extends StatelessWidget {
  final Scr3WorkoutDetails workout;

  const Scr3WorkoutCard({
    super.key,
    required this.workout,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeaderRow(),
        const SizedBox(height: 16.0),
        _buildWorkoutDetails(),
        if (workout.note != null) ...[
          const SizedBox(height: 16.0),
          _buildNoteText(),
        ]
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildWorkoutNameText(),
          if (workout.dayOfWeekName != null) _buildDayOfWeekRow(),
        ],
      ),
    );
  }

  Widget _buildWorkoutDetails() {
    List<Widget> boxes = [];

    Scr3WorkoutBoxes(
      workout: workout,
      addEntry: (String name, String value, IconData iconData) {
        boxes.add(
          DetailBox(name: name, value: value, icon: iconData),
        );
      },
    );

    return SizedBox(
      height: Scr3WorkoutExerciseCard.detailBoxHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: Scr3WorkoutExerciseCard.paddingSize),
          ...boxes,
          const SizedBox(width: Scr3WorkoutExerciseCard.paddingSize),
        ],
      ),
    );
  }

  Widget _buildWorkoutNameText() {
    return Expanded(
      child: Text(
        workout.name,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildDayOfWeekRow() {
    return Row(
      children: [
        const Icon(Icons.calendar_today, size: 18.0),
        const SizedBox(width: 4.0),
        Text(
          workout.dayOfWeekName!,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildNoteText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        workout.note!,
        style: const TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
