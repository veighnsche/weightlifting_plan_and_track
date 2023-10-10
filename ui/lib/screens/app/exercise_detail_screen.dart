import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/widgets/future_stream_builder.dart';

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
    return AppDetailShell(
      title: "Exercise Details",
      body: FutureStreamBuilder(
        futureStream:
            AppExerciseService().exerciseDetailsSubscription(exerciseId),
        builder: (context, exercise) {
          return _buildExerciseDetails(exercise);
        },
      ),
    );
  }

  Widget _buildExerciseDetails(Scr4ExerciseDetails exercise) {
    return SingleChildScrollView(
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
    );
  }
}
