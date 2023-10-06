import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/utils/scr3_exercise_card_utils.dart';

import '../../models/app/screen_models/workout_details.dart';

class Scr3WorkoutExerciseCard extends StatelessWidget {
  final Scr3Exercise exercise;

  static const double _paddingSize = 16.0;
  static const double _iconSize = 30.0;
  static const double _detailBoxHeight = 80.0;

  const Scr3WorkoutExerciseCard({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: _paddingSize),
        _buildName(),
        if (exercise.note != null) _buildNote(),
        const SizedBox(height: _paddingSize),
        _buildExerciseDetails(),
        const SizedBox(height: 2 * _paddingSize),

        const Padding(
          padding: EdgeInsets.symmetric(horizontal: _paddingSize),
          child: Divider(color: Colors.grey, thickness: 1.5),
        ), // Adding the divider
        _buildActionButtons() // Adding the row of buttons
      ],
    );
  }

  Widget _buildName() {
    return _paddedRow([
      _opacityRotatedIcon(Icons.fitness_center),
      const SizedBox(width: _paddingSize),
      Expanded(
        child: Text(
          exercise.name,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey[800],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      )
    ]);
  }

  Widget _buildExerciseDetails() {
    List<Widget> boxes = [];

    HandleExerciseDetails(
      exercise: exercise,
      addEntry: (String key, String value, IconData iconData) {
        boxes.add(
          _detailBox(key, value, iconData),
        );
      },
    );

    return SizedBox(
      height: _detailBoxHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: _paddingSize),
          ...boxes,
          const SizedBox(width: _paddingSize),
        ],
      ),
    );
  }

  Padding _buildNote() {
    return _padding(
      Text(
        exercise.note!,
        style: TextStyle(
          color: Colors.blueGrey[600],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  // Helper Functions
  Padding _padding(Widget child) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _paddingSize),
      child: child,
    );
  }

  Row _paddedRow(List<Widget> children) {
    return Row(
      children: [
        const SizedBox(width: _paddingSize),
        ...children,
      ],
    );
  }

  Widget _opacityRotatedIcon(IconData icon) {
    return Opacity(
      opacity: 0.3,
      child: Transform.rotate(
        angle: (3 / 8) * 2 * pi,
        child: Icon(
          icon,
          color: Colors.black,
          size: _iconSize,
        ),
      ),
    );
  }

  Widget _detailBox(String key, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      width: _detailBoxHeight,
      height: _detailBoxHeight,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Icon
          ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Transform.rotate(
              angle: (345 / 360) * 2 * pi,
              child: Icon(
                icon,
                size: _detailBoxHeight,
                color: Colors.grey[200],
              ),
            ),
          ),
          // Key and Value Texts
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(key, textAlign: TextAlign.center),
              Text(value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            label: const Text("Sets"),
            icon: const Icon(Icons.format_list_numbered),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
