import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animations/card_animation.dart';
import '../../core/app_shell.dart';
import '../../models/app/screens/workout_list.dart';
import '../../services/app/workout_service.dart';
import '../../widgets/app/workout_item.dart';

class AppWorkoutListScreen extends StatelessWidget {
  const AppWorkoutListScreen({super.key});

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
            await Navigator.pushNamed(context, '/app/workouts/create');
          },
        ),
      ],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<ScrWorkoutList>(
      stream: AppWorkoutService().subscribeToWorkouts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          return const Center(child: Text('Error loading workouts'));
        }

        if (!snapshot.hasData || snapshot.data!.workouts.isEmpty) {
          return const Center(child: Text('No workouts available'));
        }

        final ScrWorkoutList workoutListScreenModel = snapshot.data!;
        return _buildWorkoutsList(workoutListScreenModel.workouts);
      },
    );
  }

  Widget _buildWorkoutsList(List<ScrWorkoutItem> workouts) {
    return ListView.builder(
      itemCount: workouts.length,
      addAutomaticKeepAlives: true,
      itemBuilder: (BuildContext context, int index) {
        return CardAnimation(
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: 100 * index),
          child: WorkoutItem(workout: workouts[index]),
        );
      },
    );
  }
}
