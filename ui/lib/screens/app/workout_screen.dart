import 'package:flutter/material.dart';
import 'package:graphql/client.dart';

import '../../core/app_shell.dart';
import '../../models/app/screens/workout_list_screen_model.dart';
import '../../models/app/workout_model.dart';
import '../../services/app/workout_service.dart';
import '../../widgets/app/workout_item.dart';

class AppWorkoutScreen extends StatelessWidget {
  AppWorkoutScreen({super.key});

  final AppWorkoutService _workoutService = AppWorkoutService();

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Workouts',
      showBottomNavigationBar: true,
      showFab: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            final Object? createdWorkout =
                await Navigator.pushNamed(context, '/app/workouts/create');
            if (createdWorkout is AppWorkoutModel) {
              // TODO: Send workout to backend
              // No need to reinitialize the stream. The Hasura subscription will handle updates.
            }
          },
        ),
      ],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<QueryResult>(
      stream: _workoutService.subscribeToWorkouts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          print(snapshot.error);
          return const Center(child: Text('Error loading workouts'));
        }

        if (!snapshot.hasData || snapshot.data!.hasException) {
          print(snapshot.data);
          return const Center(child: Text('No workouts available'));
        }


        final List<dynamic> workoutData = snapshot.data!.data!['wpt_workouts'];
        final List<WorkoutListScreenWorkoutModel> workouts = workoutData
            .map((workout) => WorkoutListScreenWorkoutModel.fromJson(workout))
            .toList();

        return _buildWorkoutsList(workouts);
      },
    );
  }

  Widget _buildWorkoutsList(List<WorkoutListScreenWorkoutModel> workouts) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (BuildContext context, int index) {
        return WorkoutItem(workout: workouts[index]);
      },
    );
  }
}
