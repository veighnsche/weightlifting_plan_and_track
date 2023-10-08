import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/app/screen_models/scr4_exercise_details.dart';
import '../../services/app/exercise_service.dart';
import '../../widgets/app/scr4_completed_workout_card.dart';
import '../../widgets/app/scr4_exercise_details_card.dart';
import '../../widgets/app/scr4_workout_card.dart';
import '../../widgets/shells/app_detail_shell.dart';

class AppExerciseDetailScreen extends StatelessWidget {
  final String exerciseId;

  const AppExerciseDetailScreen({
    Key? key,
    required this.exerciseId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AppExerciseService().exerciseDetailsSubscription(exerciseId),
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
            body: const Center(child: Text('Error loading exercise')),
          );
        }

        final exercise = snapshot.data!;

        return _buildExerciseDetails(exercise);
      },
    );
  }

  Widget _buildExerciseDetails(Scr4ExerciseDetails exercise) {
    return AppDetailShell(
      title: "Exercise Details",
      body: SingleChildScrollView(
        child: Column(
          children: [
            Scr4ExerciseDetailsCard(exercise: exercise),
            const Divider(),
            ...exercise.workouts
                .map((workout) => Scr4WorkoutCard(workout: workout)),
            const Divider(),
            ...exercise.completedWorkouts.map((completedWorkout) =>
                Scr4CompletedWorkoutCard(completedWorkout: completedWorkout)),
          ],
        ),
      ),
    );
  }
}
