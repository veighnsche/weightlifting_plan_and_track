import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animations/card_animation.dart';
import '../../models/app/screen_models/workout_list.dart';
import '../../services/app/workout_service.dart';
import '../../widgets/app/workout_card.dart';

class AppWorkoutListScreen extends StatelessWidget {
  const AppWorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Scr1WorkoutList>(
      stream: AppWorkoutService().workoutListSubscription(),
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

        final Scr1WorkoutList workoutListScreenModel = snapshot.data!;

        return _buildWorkoutsList(workoutListScreenModel.workouts);
      },
    );
  }

  Widget _buildWorkoutsList(List<Scr1WorkoutItem> workouts) {
    return ListView.builder(
      itemCount: workouts.length,
      addAutomaticKeepAlives: true,
      itemBuilder: (BuildContext context, int index) {
        return CardAnimation(
          key: ValueKey(workouts[index].workoutId),
          // Ensure unique keys for each card
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: 100 * index),
          child: WorkoutCard(workout: workouts[index]),
        );
      },
    );
  }
}
