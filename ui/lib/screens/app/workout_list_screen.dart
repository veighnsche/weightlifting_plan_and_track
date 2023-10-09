import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/widgets/future_stream_builder.dart';

import '../../animations/card_animation.dart';
import '../../models/app/screen_models/scr1_workout_list.dart';
import '../../services/app/workout_service.dart';
import '../../widgets/app/scr1_workout_card.dart';

class AppWorkoutListScreen extends StatelessWidget {
  const AppWorkoutListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureStreamBuilder(
      futureStream: AppWorkoutService().scr1workoutListSubscription(),
      builder: (context, workoutListScreenModel) {
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
          child: Scr1WorkoutCard(workout: workouts[index]),
        );
      },
    );
  }
}
