import 'package:flutter/material.dart';

import '../../models/app/screens/workout_list.dart';
import '../diagonal_clipper.dart';

class WorkoutCard extends StatelessWidget {
  final Scr1WorkoutItem workout;

  const WorkoutCard({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    final today = (DateTime.now().weekday - 1) % 7;
    final isToday = workout.dayOfWeek == today;

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      // padding: const EdgeInsets.all(16.0),
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
                if (isToday) _buildTodayIndicator(),
                _buildName(),
                const SizedBox(height: 8.0),
                _buildExerciseList(),
                const SizedBox(height: 8.0),
                if (workout.note != null) _buildNote(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildDayOfWeek(),
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

  Widget _buildTodayIndicator() {
    return Column(
      children: [
        Text(
          'Today\'s workout:',
          style: TextStyle(color: Colors.blueGrey[600]),
        ),
        const SizedBox(height: 4.0),
      ],
    );
  }

  Text _buildName() {
    return Text(
      workout.name,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[800],
      ),
      maxLines: 1, // Set a maximum of one line.
      overflow: TextOverflow.ellipsis, // Add ellipsis when overflow happens.
    );
  }

  Row _buildDayOfWeek() {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          color: Colors.blueGrey[600],
          size: 16.0,
        ),
        const SizedBox(width: 6.0),
        Text(
          workout.dayOfWeekName,
          style: TextStyle(color: Colors.blueGrey[600]),
        ),
      ],
    );
  }

  Padding _buildNote() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        workout.note!,
        style: TextStyle(
          color: Colors.blueGrey[600],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  Widget _buildExerciseList() {
    // Check if there are any exercises.
    if (workout.exercises.isEmpty) {
      return _buildNoExercisesText();
    }

    String exercisesText = _generateExercisesText();
    String totalSetsText = _generateTotalSetsText();

    return Row(
      children: [
        Icon(
          Icons.fitness_center,
          color: Colors.blueGrey[700],
          size: 18.0,
        ),
        const SizedBox(width: 8.0),
        Expanded(
          // To ensure the text does not overflow.
          child: RichText(
            overflow: TextOverflow.ellipsis,
            maxLines: 3,
            text: TextSpan(
              children: [
                TextSpan(
                  text: exercisesText,
                  style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,  // Increased font size
                  ),
                ),
                TextSpan(
                  text: ' $totalSetsText',
                  style: TextStyle(
                    color: Colors.blueGrey[700],
                    fontSize: 16.0,  // Increased font size
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  String _generateExercisesText() {
    String combinedExercises = workout.exercises.take(3).join(', ');

    if (workout.totalExercises > 3) {
      combinedExercises += ', +${workout.totalExercises - 3} more';
    }

    return combinedExercises;
  }

  String _generateTotalSetsText() {
    String combinedSets = workout.totalSets.toString();

    return "$combinedSets sets";
  }

  Widget _buildNoExercisesText() {
    return Opacity(
      opacity: 0.5, // You can adjust the opacity value as needed (0.0 to 1.0)
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
              'No exercises added yet. Tap to add!',
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
