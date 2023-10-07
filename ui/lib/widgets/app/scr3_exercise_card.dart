import 'dart:math';

import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/utils/scr3_utils.dart';

import '../../models/app/screen_models/scr3_workout_details.dart';
import '../detail_box.dart';
import 'scr3_set_card.dart';

class Scr3WorkoutExerciseCard extends StatefulWidget {
  final Scr3Exercise exercise;

  static const double paddingSize = 16.0;
  static const double iconSize = 30.0;
  static const double detailBoxHeight = 80.0;

  const Scr3WorkoutExerciseCard({
    Key? key,
    required this.exercise,
  }) : super(key: key);

  @override
  State<Scr3WorkoutExerciseCard> createState() =>
      _Scr3WorkoutExerciseCardState();
}

class _Scr3WorkoutExerciseCardState extends State<Scr3WorkoutExerciseCard>
    with SingleTickerProviderStateMixin {

late AnimationController _controller;
late Animation<double> _animation;

@override
void initState() {
  super.initState();
  _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  _animation = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  );
  _controller.addListener(() {
    setState(() {});
  });
}

@override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: Scr3WorkoutExerciseCard.paddingSize),
      _buildName(),
      const SizedBox(height: Scr3WorkoutExerciseCard.paddingSize),
      _buildExerciseDetails(),
      const SizedBox(height: Scr3WorkoutExerciseCard.paddingSize),
      if (widget.exercise.note != null) _buildNote(),
      const SizedBox(height: Scr3WorkoutExerciseCard.paddingSize),
      const Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Scr3WorkoutExerciseCard.paddingSize),
        child: Divider(color: Colors.grey, thickness: 1.5),
      ),
      _buildActionButtons(),
      _buildSets(),
    ],
  );
}

Widget _buildName() {
  return _paddedRow([
    _opacityRotatedIcon(Icons.fitness_center),
    const SizedBox(width: Scr3WorkoutExerciseCard.paddingSize),
    Expanded(
      child: Text(
        widget.exercise.name,
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

  Scr3ExerciseBoxes(
    exercise: widget.exercise,
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

Padding _buildNote() {
  return _padding(
    Text(
      widget.exercise.note!,
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
    padding: const EdgeInsets.symmetric(
        horizontal: Scr3WorkoutExerciseCard.paddingSize),
    child: child,
  );
}

Row _paddedRow(List<Widget> children) {
  return Row(
    children: [
      const SizedBox(width: Scr3WorkoutExerciseCard.paddingSize),
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
        size: Scr3WorkoutExerciseCard.iconSize,
      ),
    ),
  );
}

Widget _buildActionButtons() {
  return Padding(
    padding: const EdgeInsets.only(bottom: 8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: TextButton.icon(
            label: const Text("Sets"),
            icon: const Icon(Icons.format_list_numbered),
            onPressed: () {
              setState(() {
                if (_controller.status == AnimationStatus.completed) {
                  _controller.reverse();
                } else {
                  _controller.forward();
                }
              });
            },
          ),
        ),
      ],
    ),
  );
}

Widget _buildSets() {
  return SizeTransition(
    sizeFactor: _animation,
    axisAlignment: 1.0,
    child: Column(children: [
      ...widget.exercise.sets.map((set) => Scr3SetCard(set: set)).toList(),
      const SizedBox(height: Scr3WorkoutExerciseCard.paddingSize),
    ]),
  );
}

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}}
