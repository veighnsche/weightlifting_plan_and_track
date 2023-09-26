import 'package:flutter/material.dart';

import '../../models/app/workout_model.dart';

class WorkoutItem extends StatelessWidget {
  final AppWorkoutModel workout;

  const WorkoutItem({super.key, required this.workout});

  static const days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

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
                if (workout.note != null) _buildNote(),
                const SizedBox(height: 8.0),
                ..._buildExerciseList(),
                if (workout.exercises.length > 3) _buildExerciseOverflow(),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _buildDayOfWeek(days),
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
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[800],
      ),
      overflow: TextOverflow.ellipsis,
    );
  }

  Row _buildDayOfWeek(List<String> days) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          color: Colors.blueGrey[600],
          size: 16.0,
        ),
        const SizedBox(width: 6.0),
        Text(
          days[workout.dayOfWeek!],
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

  Padding _buildExerciseOverflow() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        '+${workout.exercises.length - 3} more',
        style: TextStyle(
          color: Colors.blueGrey[600],
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }

  List<ListTile> _buildExerciseList() {
    return workout.exercises.take(3).map((exercise) {
      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          Icons.fitness_center,
          color: Colors.blueGrey[700],
        ),
        title: Text(
          exercise.name,
          style: TextStyle(color: Colors.blueGrey[700]),
        ),
      );
    }).toList();
  }
}

class DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width - 12, size.height)
      ..quadraticBezierTo(
        size.width, size.height,
        size.width, size.height - 12,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

