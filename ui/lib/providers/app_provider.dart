import 'package:flutter/foundation.dart';

import '../models/app/completed_set_model.dart';
import '../models/app/exercise_model.dart';
import '../models/app/set_model.dart';
import '../models/app/workout_model.dart';

class AppProvider extends ChangeNotifier {
  List<AppWorkoutModel> _workouts = [];
  List<AppExerciseModel> _exercises = [];
  List<AppSetModel> _sets = [];
  List<AppCompletedSetModel> _completedSets = [];

  List<AppWorkoutModel> get workouts => _workouts;
  List<AppExerciseModel> get exercises => _exercises;
  List<AppSetModel> get sets => _sets;
  List<AppCompletedSetModel> get completedSets => _completedSets;

  void setWorkouts(List<AppWorkoutModel> workouts) {
    _workouts = workouts;
    notifyListeners();
  }

  void setExercises(List<AppExerciseModel> exercises) {
    _exercises = exercises;
    notifyListeners();
  }

  void setSets(List<AppSetModel> sets) {
    _sets = sets;
    notifyListeners();
  }

  void setCompletedSets(List<AppCompletedSetModel> completedSets) {
    _completedSets = completedSets;
    notifyListeners();
  }
}