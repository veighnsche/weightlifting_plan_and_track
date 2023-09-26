import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weightlifting_plan_and_track/models/app/workout_model.dart';

import '../../core/app_shell.dart';
import '../../providers/app/workouts_provider.dart';
import '../../widgets/app/workout_item.dart';

class AppWorkoutScreen extends StatefulWidget {
  const AppWorkoutScreen({super.key});

  @override
  _AppWorkoutScreenState createState() => _AppWorkoutScreenState();
}

class _AppWorkoutScreenState extends State<AppWorkoutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AppWorkoutsProvider>().fetchWorkouts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final workoutsProvider = context.watch<AppWorkoutsProvider>();

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
              workoutsProvider.addWorkout(createdWorkout);
            }
          },
        ),
      ],
      body: _buildBody(workoutsProvider),
    );
  }

  Widget _buildBody(AppWorkoutsProvider workoutsProvider) {
    if (workoutsProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (workoutsProvider.workouts.isEmpty) {
      return const Center(child: Text('No workouts available'));
    }

    return _buildWorkoutsList(workoutsProvider.workouts);
  }

  Widget _buildWorkoutsList(List<AppWorkoutModel> workouts) {
    return ListView.builder(
      itemCount: workouts.length,
      itemBuilder: (BuildContext context, int index) {
        return WorkoutItem(workout: workouts[index]);
      },
    );
  }
}
