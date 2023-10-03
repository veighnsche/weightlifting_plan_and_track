import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animations/card_animation.dart';
import '../../models/app/screens/exercise_list.dart';
import '../../services/app/exercise_service.dart';
import '../../widgets/app/exercise_card.dart';

class AppExerciseListScreen extends StatelessWidget {
  const AppExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Scr2ExerciseList>(
      stream: AppExerciseService().subscribeToExerciseListScreen(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          if (kDebugMode) {
            print(snapshot.error);
          }
          return const Center(child: Text('Error loading exercises'));
        }

        if (!snapshot.hasData || snapshot.data!.exercises.isEmpty) {
          return const Center(child: Text('No exercises available'));
        }

        final Scr2ExerciseList exerciseListScreenModel = snapshot.data!;
        return _buildExercisesList(exerciseListScreenModel.exercises);
      },
    );
  }

  Widget _buildExercisesList(List<Scr2ExerciseItem> exercises) {
    return ListView.builder(
      itemCount: exercises.length,
      addAutomaticKeepAlives: true,
      itemBuilder: (BuildContext context, int index) {
        return CardAnimation(
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: 100 * index),
          child: ExerciseCard(exercise: exercises[index]),
        );
      },
    );
  }
}
