class WorkoutListScreenModel {
  final List<WorkoutListScreenWorkoutModel> workouts;

  WorkoutListScreenModel({required this.workouts});

  factory WorkoutListScreenModel.fromJson(Map<String, dynamic> json) {
    return WorkoutListScreenModel(
      workouts: (json['wpt_workouts'] as List)
          .map((data) => WorkoutListScreenWorkoutModel.fromJson(data))
          .toList(),
    );
  }

  bool get isEmpty => workouts.isEmpty;
}

class WorkoutListScreenWorkoutModel {
  final String workoutId;
  final String name;
  final int? dayOfWeek;
  final String? note;
  final List<WorkoutListScreenExerciseModel> exercises;
  final int totalExercises;
  final int totalSets;

  WorkoutListScreenWorkoutModel({
    required this.workoutId,
    required this.name,
    this.dayOfWeek,
    this.note,
    required this.exercises,
    required this.totalExercises,
    required this.totalSets,
  });

  factory WorkoutListScreenWorkoutModel.fromJson(Map<String, dynamic> json) {
    int getTotalCount(Map<String, dynamic> json, String key) {
      var value = json[key];
      if (value is List && value.isEmpty) {
        return 0;
      } else {
        return value['aggregate']['count'];
      }
    }

    return WorkoutListScreenWorkoutModel(
      workoutId: json['workout_id'],
      name: json['name'],
      dayOfWeek: json['day_of_week'],
      note: json['note'],
      exercises: (json['wpt_workout_exercises'] as List)
          .map((data) => WorkoutListScreenExerciseModel.fromJson(data))
          .toList(),
      totalExercises: getTotalCount(json, 'totalExercises'),
      totalSets: getTotalCount(json, 'totalSets'),
    );
  }

}

class WorkoutListScreenExerciseModel {
  final String name;

  WorkoutListScreenExerciseModel({required this.name});

  factory WorkoutListScreenExerciseModel.fromJson(Map<String, dynamic> json) {
    return WorkoutListScreenExerciseModel(name: json['exercise']['name']);
  }
}
