import '../../models/app/screen_models/scr1_workout_list.dart';
import '../../models/app/screen_models/scr2_exercise_list.dart';
import '../../models/app/screen_models/scr3_workout_details.dart';
import '../../models/app/screen_models/scr4_exercise_details.dart';

class ChatWptStoreService {
  // Private constructor
  ChatWptStoreService._privateConstructor();

  // Static instance variable
  static final ChatWptStoreService _instance = ChatWptStoreService._privateConstructor();

  // Factory method to return the same instance
  factory ChatWptStoreService() {
    return _instance;
  }

  Scr1WorkoutList? workoutList;
  Scr2ExerciseList? exerciseList;
  Scr3WorkoutDetails? workoutDetails;
  Scr4ExerciseDetails? exerciseDetails;

  void setWpt({
    Scr1WorkoutList? workoutList,
    Scr2ExerciseList? exerciseList,
    Scr3WorkoutDetails? workoutDetails,
    Scr4ExerciseDetails? exerciseDetails,
  }) {
    // Null all the properties first
    this.workoutList = null;
    this.exerciseList = null;
    this.workoutDetails = null;
    this.exerciseDetails = null;

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

  Object? getWpt() {
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
}
