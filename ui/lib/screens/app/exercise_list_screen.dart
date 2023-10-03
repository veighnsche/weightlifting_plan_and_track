import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../animations/card_animation.dart';
import '../../core/app_shell.dart';

class AppExerciseListScreen extends StatelessWidget {
  const AppExerciseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Exercises',
      showBottomNavigationBar: true,
      showFab: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () async {
            await Navigator.pushNamed(context, '/app/exercises/create');
          },
        ),
      ],
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return StreamBuilder<ScrExerciseList>(
      stream: AppExerciseService().subscribeToExercises(),
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

        final ScrExerciseList exerciseListScreenModel = snapshot.data!;
        return _buildExercisesList(exerciseListScreenModel.exercises);
      },
    );
  }

  Widget _buildExercisesList(List<ScrExerciseItem> exercises) {
    return ListView.builder(
      itemCount: exercises.length,
      addAutomaticKeepAlives: true,
      itemBuilder: (BuildContext context, int index) {
        return CardAnimation(
          duration: const Duration(milliseconds: 400),
          delay: Duration(milliseconds: 100 * index),
          child: ExerciseItem(exercise: exercises[index]),
        );
      },
    );
  }
}
