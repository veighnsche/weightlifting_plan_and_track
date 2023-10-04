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

    String workoutsText = _generateWorkoutsText();

    return Row(
      children: [
        Icon(
          Icons.fitness_center,
          color: Colors.blueGrey[700],
          size: 18.0,
        ),
        const SizedBox(width: 8.0), // Spacing between icon and text.
        Expanded(
          // To ensure the text does not overflow.
          child: Text(
            workoutsText,
            style: TextStyle(
              color: Colors.blueGrey[700],
              fontWeight: FontWeight.bold, // Bold font weight
            ),
            overflow: TextOverflow.ellipsis, // Handle potential overflow.
          ),
        ),
      ],
    );
  }

  String _generateWorkoutsText() {
    // Combine the names of the first 3 workouts (or fewer) into a single string.
    String combinedWorkouts =
        exercise.workouts.take(3).map((w) => w.name).join(', ');

    // If there are more than 3 workouts, append "+X more" to the string.
    if (exercise.workouts.length > 3) {
      combinedWorkouts += ', +${exercise.workouts.length - 3} more';
    }

    return combinedWorkouts;
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
