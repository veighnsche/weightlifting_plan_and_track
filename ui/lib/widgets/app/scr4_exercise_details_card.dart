import 'package:flutter/material.dart';

import '../../models/app/screen_models/scr4_exercise_details.dart';
import '../../utils/scr4_boxes.dart';
import '../detail_box.dart';
import 'scr3_exercise_card.dart';

class Scr4ExerciseDetailsCard extends StatelessWidget {
  final Scr4ExerciseDetails exercise;

  const Scr4ExerciseDetailsCard({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16.0),
        _buildHeaderRow(),
        const SizedBox(height: 16.0),
        _buildExerciseDetails(),
        if (exercise.note != null) ...[
          const SizedBox(height: 16.0),
          _buildNoteText(),
        ],
        const SizedBox(height: 32.0),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildExerciseNameText(),
        ],
      ),
    );
  }

  Widget _buildExerciseDetails() {
    List<Widget> boxes = [];

    Scr4ExerciseBoxes(
      exercise: exercise,
      addEntry: (String name, String value, IconData iconData) {
        boxes.add(
          DetailBox(name: name, value: value, icon: iconData),
        );
      },
    );

    return SizedBox(
      height: Scr3WorkoutExerciseCard.detailBoxHeight,
      // Assuming a constant similar to the Scr3 equivalent exists
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: Scr3WorkoutExerciseCard.paddingSize),
          // Assuming a constant similar to the Scr3 equivalent exists
          ...boxes,
          const SizedBox(width: Scr3WorkoutExerciseCard.paddingSize),
          // Assuming a constant similar to the Scr3 equivalent exists
        ],
      ),
    );
  }

  Widget _buildExerciseNameText() {
    return Expanded(
      child: Text(
        exercise.name,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildNoteText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        exercise.note!,
        style: const TextStyle(
          fontSize: 16,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
