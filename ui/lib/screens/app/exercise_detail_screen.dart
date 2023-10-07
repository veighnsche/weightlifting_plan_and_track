import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../models/app/screen_models/scr4_exercise_details.dart';
import '../../services/app/exercise_service.dart';  // Assume you have a service for exercises
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
      stream: AppExerciseService().exerciseDetailsSubscription(exerciseId),  // Assume you have a method for exercise subscription
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Exercise Name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                exercise.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),

            // Exercise Note
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(exercise.note),
            ),

            // Divider
            Divider(),

            // Linked Workouts Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Linked Workouts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // List of Linked Workouts
            ...exercise.workouts.map((workout) {
              return ListTile(
                title: Text(workout.name),
                subtitle: Text(workout.note ?? ""),
                trailing: Text("Day: ${workout.dayOfWeek}"),
              );
            }).toList(),

            // Divider
            Divider(),

            // Completed Workouts Header
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Completed Workouts",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            // List of Completed Workouts
            ...exercise.completedWorkouts.map((completedWorkout) {
              return ListTile(
                title: Text(completedWorkout.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Started At: ${completedWorkout.startedAt}"),
                    Text("Max Reps: ${completedWorkout.maxReps}"),
                    Text("Min Weight: ${completedWorkout.minWeight}"),
                    Text("Max Weight: ${completedWorkout.maxWeight}"),
                    Text("Avg Rest Time: ${completedWorkout.avgRestTimeBefore}"),
                    Text("Total Volume: ${completedWorkout.totalVolume}"),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

}
