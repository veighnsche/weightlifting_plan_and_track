import 'package:flutter/material.dart';

import '../../animations/card_animation.dart';
import '../../models/app/screen_models/scr2_exercise_list.dart';
import '../../services/app/exercise_service.dart';
import '../../widgets/app/scr2_exercise_card.dart';
import '../../widgets/future_stream_builder.dart';

class AppExerciseListScreen extends StatelessWidget {
  const AppExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureStreamBuilder(
      futureStream: AppExerciseService().scr2exerciseListSubscription(),
      builder: (context, workoutListScreenModel) {
        return _buildExercisesList(workoutListScreenModel.exercises);
      },
    );
  }

  Widget _buildExercisesList(List<Scr2ExerciseItem> exercises) {
    final scrollController = ScrollController();

    return ListView.builder(
      controller: scrollController,
      itemCount: exercises.length,
      addAutomaticKeepAlives: true,
      itemBuilder: (BuildContext context, int index) {
        return CardAnimation(
          key: ValueKey(exercises[index].exerciseId),
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: 100 * index),
          child: Scr2ExerciseCard(exercise: exercises[index]),
        );
      },
    );
  }
}
