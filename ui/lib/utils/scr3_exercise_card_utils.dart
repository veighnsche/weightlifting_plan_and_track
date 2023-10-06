import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/models/app/screen_models/workout_details.dart';

class HandleExerciseDetails {
  final Scr3Exercise exercise;
  final Function(String key, String value, IconData iconData) addEntry;

  HandleExerciseDetails({required this.exercise, required this.addEntry}) {
    handleSets();
    handleReps();
    handleWeight();
    handleRest();
    handleVolume();
  }

  void handleSets() {
    if (exercise.setsCount > 0) {
      addEntry('Sets', '${exercise.setsCount}', Icons.format_list_numbered);
    }
  }

  void handleReps() {
    if (exercise.maxReps > 0) {
      addEntry('Reps', '${exercise.maxReps}', Icons.repeat);
    }
  }

  void handleWeight() {
    if (exercise.minWeight == null || exercise.maxWeight == null) return;

    if (exercise.minWeight == exercise.maxWeight && exercise.minWeight! > 0) {
      addEntry('Weight', '${exercise.maxWeight}kg', Icons.line_weight);
    } else if (exercise.minWeight != exercise.maxWeight &&
        exercise.minWeight! > 0 &&
        exercise.maxWeight! > 0) {
      addEntry('Weight', '${exercise.minWeight} - ${exercise.maxWeight}kg',
          Icons.line_weight);
    } else {
      if (exercise.minWeight! == 0 && exercise.maxWeight! == 0) {
        addEntry(
            'Total Reps', '${exercise.totalReps}', Icons.format_list_numbered);
      }
      if (exercise.minWeight! > 0) {
        addEntry('Min Weight', '${exercise.minWeight}kg', Icons.arrow_downward);
      }
      if (exercise.maxWeight! > 0) {
        addEntry('Max Weight', '${exercise.maxWeight}kg', Icons.arrow_upward);
      }
    }
  }

  void handleRest() {
    if (exercise.maxRest != null && exercise.maxRest! > 0) {
      final minutes = (exercise.maxRest! / 60).floor();
      final seconds = exercise.maxRest! % 60;
      final displayTime = seconds == 0
          ? '${minutes}m'
          : minutes == 0
              ? '${seconds}s'
              : '${minutes}m ${seconds}s';
      addEntry('Rest', displayTime, Icons.timer);
    }
  }

  void handleVolume() {
    if (exercise.totalVolume != null && exercise.totalVolume! > 0) {
      addEntry('Volume', '${exercise.totalVolume}kg', Icons.volume_up);
    }
  }
}
