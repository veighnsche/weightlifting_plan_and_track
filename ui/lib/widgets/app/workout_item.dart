import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

    return Slidable(
      key: ValueKey(workout.workoutId),
      startActionPane: _buildStartActionPane(),
      endActionPane: _buildEndActionPane(),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        padding: const EdgeInsets.all(16.0),
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
            Column(
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
            Positioned(
              top: 0,
              right: 0,
              child: _buildDayOfWeek(days),
            ),
          ],
        ),
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

  ActionPane _buildStartActionPane() {
    return ActionPane(
      motion: const ScrollMotion(),
      extentRatio: 0.2,
      children: [
        SlidableAction(
          onPressed: (context) {},
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          icon: Icons.edit,
          label: 'Edit',
        ),
      ],
    );
  }

  ActionPane _buildEndActionPane() {
    return ActionPane(
      motion: const ScrollMotion(),
      extentRatio: 0.2,
      children: [
        SlidableAction(
          onPressed: (context) {},
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          icon: Icons.play_arrow,
          label: 'Start',
        ),
      ],
    );
  }
}
