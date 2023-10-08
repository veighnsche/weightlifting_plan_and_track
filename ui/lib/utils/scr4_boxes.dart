import 'package:flutter/material.dart';

import '../models/app/screen_models/scr4_exercise_details.dart';

class Scr4ExerciseBoxes {
  final Scr4ExerciseDetails exercise;
  final Function(String name, String value, IconData iconData) addEntry;

  Scr4ExerciseBoxes(
      {required this.exercise, required this.addEntry}) {
    handleTotalCompletedWorkouts();
    handleTotalCompletedVolume();
    handleAvgDiffInTotalVolume();
  }

  void handleTotalCompletedWorkouts() {
    if (exercise.totalCompletedWorkouts > 0) {
      addEntry('Compl. Workouts', '${exercise.totalCompletedWorkouts}',
          Icons.fitness_center);
    }
  }

  String formatVolume(double volume) {
    if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}t';
    } else {
      return '${volume.toString()}kg';
    }
  }

  void handleTotalCompletedVolume() {
    if (exercise.totalCompletedVolume > 0) {
      addEntry(
        'Total Volume',
        formatVolume(exercise.totalCompletedVolume),
        Icons.volume_up,
      );
    }
  }

  void handleAvgDiffInTotalVolume() {
    if (exercise.avgDiffInTotalVolume > 0) {
      addEntry(
        'Avg Diff. Volume',
        formatVolume(exercise.avgDiffInTotalVolume),
        Icons.trending_up,
      );
    }
  }
}

class Scr4CompletedWorkoutBoxes {
  final Scr4CompletedWorkout completedWorkout;
  final Function(String name, String value, IconData iconData) addEntry;

  Scr4CompletedWorkoutBoxes(
      {required this.completedWorkout, required this.addEntry}) {
    handleCompletedSets();
    handleMaxReps();
    handleMinWeight();
    handleMaxWeight();
    handleTotalVolume();
    handlePlannedTotalVolume();
  }

  void handleCompletedSets() {
    if (completedWorkout.completedSets > 0) {
      addEntry('Completed Sets', '${completedWorkout.completedSets}',
          Icons.format_list_numbered);
    }
  }

  void handleMaxReps() {
    if (completedWorkout.maxReps! > 0) {
      addEntry('Max Reps', '${completedWorkout.maxReps}', Icons.repeat);
    }
  }

  void handleMinWeight() {
    if (completedWorkout.minWeight != null && completedWorkout.minWeight! > 0) {
      addEntry('Min Weight', '${completedWorkout.minWeight}kg',
          Icons.arrow_downward);
    }
  }

  void handleMaxWeight() {
    if (completedWorkout.maxWeight != null && completedWorkout.maxWeight! > 0) {
      addEntry('Max Weight', '${completedWorkout.maxWeight}kg',
          Icons.arrow_upward);
    }
  }

  void handleTotalVolume() {
    if (completedWorkout.totalVolume != null &&
        completedWorkout.totalVolume! > 0) {
      addEntry('Total Volume', '${completedWorkout.totalVolume}kg',
          Icons.volume_up);
    }
  }

  void handlePlannedTotalVolume() {
    if (completedWorkout.plannedTotalVolume != null &&
        completedWorkout.plannedTotalVolume! > 0) {
      addEntry('Planned Volume', '${completedWorkout.plannedTotalVolume}kg',
          Icons.calendar_view_day);
    }
  }
}
