import 'package:weightlifting_plan_and_track/models/app/screen_models/abstract.dart';

import '../../models/app/screen_models/scr1_workout_list.dart';
import '../../models/app/screen_models/scr2_exercise_list.dart';
import '../../models/app/screen_models/scr3_workout_details.dart';
import '../../models/app/screen_models/scr4_exercise_details.dart';

/// A Singleton service to store and manage workout and exercise data.
class ChatWptStoreService {
  // Private constructor
  ChatWptStoreService._privateConstructor();

  // Static instance variable
  static final ChatWptStoreService _instance =
      ChatWptStoreService._privateConstructor();

  // Factory method to return the same instance
  factory ChatWptStoreService() {
    return _instance;
  }

  Scr1WorkoutList? workoutList;
  Scr2ExerciseList? exerciseList;
  Scr3WorkoutDetails? workoutDetails;
  Scr4ExerciseDetails? exerciseDetails;

  /// Sets the workout or exercise data. Previous data will be cleared.
  void setWpt({
    Scr1WorkoutList? workoutList,
    Scr2ExerciseList? exerciseList,
    Scr3WorkoutDetails? workoutDetails,
    Scr4ExerciseDetails? exerciseDetails,
  }) {
    // Ensure only one parameter is provided
    assert(
        (workoutList != null ? 1 : 0) +
                (exerciseList != null ? 1 : 0) +
                (workoutDetails != null ? 1 : 0) +
                (exerciseDetails != null ? 1 : 0) ==
            1,
        'Only one parameter should be provided.');

    // Null all the properties first
    clearStore();

    // Then set the provided values
    if (workoutList != null) {
      this.workoutList = workoutList;
    } else if (exerciseList != null) {
      this.exerciseList = exerciseList;
    } else if (workoutDetails != null) {
      this.workoutDetails = workoutDetails;
    } else if (exerciseDetails != null) {
      this.exerciseDetails = exerciseDetails;
    }
  }

  /// Retrieves the current workout or exercise data.
  ScreenModel? getWpt() {
    if (workoutList != null) {
      return workoutList;
    } else if (exerciseList != null) {
      return exerciseList;
    } else if (workoutDetails != null) {
      return workoutDetails;
    } else if (exerciseDetails != null) {
      return exerciseDetails;
    } else {
      return null;
    }
  }

  /// Checks if there's any data stored.
  bool get hasData {
    return workoutList != null ||
        exerciseList != null ||
        workoutDetails != null ||
        exerciseDetails != null;
  }

  /// Retrieves the type of the stored data.
  Type? get dataType {
    if (workoutList != null) {
      return Scr1WorkoutList;
    } else if (exerciseList != null) {
      return Scr2ExerciseList;
    } else if (workoutDetails != null) {
      return Scr3WorkoutDetails;
    } else if (exerciseDetails != null) {
      return Scr4ExerciseDetails;
    } else {
      return null;
    }
  }

  /// Clears all stored data.
  void clearStore() {
    workoutList = null;
    exerciseList = null;
    workoutDetails = null;
    exerciseDetails = null;
  }
}
