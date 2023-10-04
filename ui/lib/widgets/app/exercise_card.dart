import 'dart:math';

import 'package:flutter/material.dart';

import '../../models/app/screens/exercise_list.dart';
import '../diagonal_clipper.dart';

class ExerciseCard extends StatelessWidget {
  final Scr2ExerciseItem exercise;

  const ExerciseCard({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              // Match card's border radius
              child: Opacity(
                opacity: 0.3, // Adjust opacity as needed
                child: Transform.rotate(
                  angle: (3/8) * 2 * pi,
                  child: const Icon(
                    Icons.fitness_center,
                    color: Colors.black,
                    size: 60, // Adjust size as needed
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipPath(
              clipper: DiagonalClipper(),
              child: Container(
                width: 48, // Adjust as necessary
                height: 48, // Adjust as necessary
                color: Colors.blueGrey.shade400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildName(),
                const SizedBox(height: 8.0),
                _buildWorkoutList(),
                const SizedBox(height: 8.0),
                if (exercise.note != null) _buildNote(),
              ],
            ),
          ),
          if (exercise.personalRecord != null)
            Positioned(
              top: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildPersonalRecord(),
              ),
            ),
          const Positioned(
            bottom: 2,
            right: 2,
            child: Icon(Icons.play_arrow, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Text _buildName() {
    return Text(
      exercise.name,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[800],
      ),
      maxLines: 1, // Set a maximum of one line.
      overflow: TextOverflow.ellipsis, // Add ellipsis when overflow happens.
    );
  }

  Row _buildPersonalRecord() {
    return Row(
      children: [
        Icon(
          Icons.stars,
          color: Colors.blueGrey[600],
          size: 16.0,
        ),
        const SizedBox(width: 6.0),
        Text(
          '${exercise.personalRecord}kg',
          style: TextStyle(color: Colors.blueGrey[600]),
        ),
      ],
    );
  }

  Padding _buildNote() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        exercise.note!,
        style: TextStyle(
          color: Colors.blueGrey[600],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildWorkoutList() {
    // Check if there are any workouts.
    if (exercise.workouts.isEmpty) {
      return _buildNoWorkoutsText();
    }

    List<TextSpan> workoutsSpans = _generateWorkoutsTextSpans();

    return RichText(
      text: TextSpan(
        style: TextStyle(
          fontSize: 16, // Setting font size to 16.
          color: Colors.blueGrey[700],
          fontWeight: FontWeight.bold, // Default to bold font weight.
        ),
        children: workoutsSpans,
      ),
      overflow: TextOverflow.ellipsis, // Handle potential overflow.
    );
  }

  List<TextSpan> _generateWorkoutsTextSpans() {
    List<TextSpan> spans = [];

    for (var i = 0; i < exercise.workouts.take(3).length; i++) {
      var workout = exercise.workouts[i];
      if (i != 0) {
        spans.add(const TextSpan(text: ', '));
      }
      spans.add(TextSpan(text: workout.name));
      if (workout.workingWeight == null) {
        continue;
      }
      spans.add(TextSpan(
          text: ' ${workout.workingWeight}',
          style: const TextStyle(fontWeight: FontWeight.normal)));
      spans.add(const TextSpan(text: 'kg', style: TextStyle(fontSize: 12.0)));
    }

    if (exercise.workouts.length > 3) {
      spans.add(TextSpan(text: ', +${exercise.workouts.length - 3} more'));
    }

    return spans;
  }

  Widget _buildNoWorkoutsText() {
    return Opacity(
      opacity: 0.5,
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: Colors.blueGrey[700],
            size: 18.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              'No workouts associated. Tap to add!',
              style: TextStyle(
                color: Colors.blueGrey[700],
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
