import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/utils/ints.dart';

import '../models/app/screen_models/scr3_workout_details.dart';

class Scr3WorkoutBoxes {
  final Scr3WorkoutDetails workout;
  final Function(String name, String value, IconData iconData) addEntry;

  Scr3WorkoutBoxes({required this.workout, required this.addEntry}) {
    handleTotalExercises();
    handleTotalSets();
    handleTotalVolume();
    handleTotalTime();
  }

  void handleTotalExercises() {
    if (workout.totalExercises > 0) {
      addEntry('Exercises', workout.totalExercises.toCustomString(),
          Icons.fitness_center);
    }
  }

  void handleTotalSets() {
    if (workout.totalSets > 0) {
      addEntry('Sets', workout.totalSets.toCustomString(),
          Icons.format_list_numbered);
    }
  }

  String formatVolume(double volume) {
    if (volume >= 1000) {
      return '${(volume / 1000).toCustomString()}t';
    } else {
      return '${volume.toCustomString()}kg';
    }
  }

  void handleTotalVolume() {
    if (workout.totalVolume > 0) {
      addEntry(
        'Volume',
        formatVolume(workout.totalVolume.toDouble()),
        Icons.volume_up,
      );
    }
  }

  void handleTotalTime() {
    if (workout.totalTime > 0) {
      final hours = (workout.totalTime / 3600).floor();
      final remainingAfterHours = workout.totalTime % 3600;
      final minutes = (remainingAfterHours / 60).floor();
      final seconds = remainingAfterHours % 60;

      String displayTime;

      if (hours > 0) {
        if (minutes == 0) {
          displayTime = '${hours}h';
        } else {
          displayTime = '${hours}h ${minutes}m';
        }
      } else if (minutes > 0) {
        if (seconds == 0) {
          displayTime = '${minutes}m';
        } else {
          displayTime = '${minutes}m ${seconds}s';
        }
      } else {
        displayTime = '${seconds}s';
      }

      addEntry('Time', displayTime, Icons.timer);
    }
  }
}

class Scr3ExerciseBoxes {
  final Scr3Exercise exercise;
  final Function(String name, String value, IconData iconData) addEntry;

  Scr3ExerciseBoxes({required this.exercise, required this.addEntry}) {
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
      addEntry('Weight', '${exercise.maxWeight?.toCustomString()}kg',
          Icons.line_weight);
    } else if (exercise.minWeight != exercise.maxWeight &&
        exercise.minWeight! > 0 &&
        exercise.maxWeight! > 0) {
      addEntry(
          'Weight',
          '${exercise.minWeight?.toCustomString()} - ${exercise.maxWeight?.toCustomString()}kg',
          Icons.line_weight);
    } else {
      if (exercise.minWeight! == 0 && exercise.maxWeight! == 0) {
        addEntry(
            'Total Reps', '${exercise.totalReps}', Icons.format_list_numbered);
      }
      if (exercise.minWeight! > 0) {
        addEntry('Min Weight', '${exercise.minWeight?.toCustomString()}kg',
            Icons.arrow_downward);
      }
      if (exercise.maxWeight! > 0) {
        addEntry('Max Weight', '${exercise.maxWeight?.toCustomString()}kg',
            Icons.arrow_upward);
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
      addEntry('Volume', '${exercise.totalVolume?.toCustomString()}kg', Icons.volume_up);
    }
  }
}

class Scr3SetBoxes {
  final Scr3Set setDetails;
  final Function(String name, String value, IconData iconData) addEntry;

  Scr3SetBoxes({required this.setDetails, required this.addEntry}) {
    handleSetNumber();
    handleReps();
    handleWeight();
    handleRest();
  }

  void handleSetNumber() {
    if (setDetails.setNumber > 0) {
      addEntry('Set', '${setDetails.setNumber}', Icons.format_list_numbered);
    }
  }

  void handleReps() {
    if (setDetails.reps > 0) {
      addEntry('Reps', '${setDetails.reps}', Icons.repeat);
    }
  }

  void handleWeight() {
    if (setDetails.weight != null && setDetails.weight! > 0) {
      addEntry('Weight', '${setDetails.weight?.toCustomString()}kg', Icons.line_weight);
    }
  }

  void handleRest() {
    if (setDetails.restTimeBefore != null && setDetails.restTimeBefore! > 0) {
      final minutes = (setDetails.restTimeBefore! / 60).floor();
      final seconds = setDetails.restTimeBefore! % 60;
      final displayTime = seconds == 0
          ? '${minutes}m'
          : minutes == 0
              ? '${seconds}s'
              : '${minutes}m ${seconds}s';
      addEntry('Rest', displayTime, Icons.timer);
    }
  }
}
