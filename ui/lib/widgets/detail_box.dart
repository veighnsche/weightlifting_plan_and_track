import 'dart:math';

import 'package:flutter/material.dart';

import 'app/scr3_exercise_card.dart';

class DetailBox extends StatelessWidget {
  final String name;
  final String value;
  final IconData icon;

  const DetailBox({
    super.key,
    required this.name,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      width: Scr3WorkoutExerciseCard.detailBoxHeight,
      height: Scr3WorkoutExerciseCard.detailBoxHeight,
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
                size: Scr3WorkoutExerciseCard.detailBoxHeight,
                color: Colors.grey[200],
              ),
            ),
          ),
          // Key and Value Texts
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, textAlign: TextAlign.center),
              Text(value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
