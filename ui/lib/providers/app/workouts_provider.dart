import 'package:flutter/foundation.dart';

import '../../models/app/workout_model.dart';
import '../../services/app/workout_service.dart';

class AppWorkoutsProvider extends ChangeNotifier {
  final AppWorkoutService _workoutService = AppWorkoutService();

  List<AppWorkoutModel> _workouts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppWorkoutModel> get workouts => _workouts;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  void _sortWorkouts() {
    int today = (DateTime.now().weekday - 1) % 7;
    _workouts.sort((a, b) {
      if (a.dayOfWeek == null && b.dayOfWeek == null) return 0;
      if (a.dayOfWeek == null) return 1;
      if (b.dayOfWeek == null) return -1;

      int adjustedA = (a.dayOfWeek! - today) % 7;
      int adjustedB = (b.dayOfWeek! - today) % 7;

      return adjustedA.compareTo(adjustedB);
    });
  }

  void fetchWorkouts() async {
    _isLoading = true;
    notifyListeners();

    try {
      _workouts = await _workoutService.getAll();
      _sortWorkouts();
    } catch (error) {
      _errorMessage = error.toString();
      if (kDebugMode) {
        print(error);
      }
      rethrow; // Re-throw the caught error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addWorkout(AppWorkoutModel workout) {
    _workouts.add(workout);
    _sortWorkouts();
    notifyListeners();
  }
}
