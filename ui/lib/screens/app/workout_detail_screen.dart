import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/app/screen_models/scr3_workout_details.dart';
import '../../services/app/workout_service.dart';
import '../../widgets/add_separators.dart';
import '../../widgets/app/scr3_completed_workout_card.dart';
import '../../widgets/app/scr3_exercise_card.dart';
import '../../widgets/app/scr3_workout_details_card.dart';
import '../../widgets/shells/app_detail_shell.dart';

class AppWorkoutDetailScreen extends StatelessWidget {
  final String workoutId;

  const AppWorkoutDetailScreen({
    super.key,
    required this.workoutId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AppWorkoutService().workoutDetailsSubscription(workoutId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Error loading workout')),
          );
        }

        final workout = snapshot.data!;

        return _buildWorkoutDetails(workout);
      },
    );
  }

  Widget _buildWorkoutDetails(Scr3WorkoutDetails workout) {
    return AppDetailShell(
      title: "Workout Details",
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Scr3WorkoutDetailsCard(workout: workout),
            _buildSectionTitle('Exercises', Colors.blueGrey[200]!),
            ..._buildExercises(workout),
            _buildSectionTitle('Completed Workouts', Colors.blueGrey[200]!),
            ..._buildCompletedWorkouts(workout),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, Color backgroundColor) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  List<Widget> _buildExercises(Scr3WorkoutDetails workout) {
    return addSeparators(
      const Divider(),
      workout.exercises
          .map((e) => Scr3WorkoutExerciseCard(exercise: e))
          .toList(),
    );
  }

  List<Widget> _buildCompletedWorkouts(Scr3WorkoutDetails workout) {
    return addSeparators(
      const Divider(),
      workout.completedWorkouts
          .map((cw) => Scr3CompletedWorkoutCard(completedWorkout: cw))
          .toList(),
    );
  }
}
