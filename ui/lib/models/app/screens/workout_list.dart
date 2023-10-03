class ScrWorkoutList {
  final List<ScrWorkoutItem> workouts;

  ScrWorkoutList({required this.workouts});

  factory ScrWorkoutList.fromJson(Map<String, dynamic> json) {
    return ScrWorkoutList(
      workouts: (json['wpt_workouts'] as List)
          .map((data) => ScrWorkoutItem.fromJson(data))
          .toList(),
    );
  }

  bool get isEmpty => workouts.isEmpty;
}

class ScrWorkoutItem {
  final String workoutId;
  final String name;
  final int? dayOfWeek;
  final String? note;
  final List<ScrExerciseItem> exercises;
  final int totalExercises;
  final int totalSets;

  ScrWorkoutItem({
    required this.workoutId,
    required this.name,
    this.dayOfWeek,
    this.note,
    required this.exercises,
    required this.totalExercises,
    required this.totalSets,
  });

  factory ScrWorkoutItem.fromJson(Map<String, dynamic> json) {
    int getTotalCount(Map<String, dynamic> json, String key) {
      var value = json[key];
      if (value is List && value.isEmpty) {
        return 0;
      } else {
        return value['aggregate']['count'];
      }
    }

    return ScrWorkoutItem(
      workoutId: json['workout_id'],
      name: json['name'],
      dayOfWeek: json['day_of_week'],
      note: json['note'],
      exercises: (json['wpt_workout_exercises'] as List)
          .map((data) => ScrExerciseItem.fromJson(data))
          .toList(),
      totalExercises: getTotalCount(json, 'totalExercises'),
      totalSets: getTotalCount(json, 'totalSets'),
    );
  }

}

class ScrExerciseItem {
  final String name;

  ScrExerciseItem({required this.name});

  factory ScrExerciseItem.fromJson(Map<String, dynamic> json) {
    return ScrExerciseItem(name: json['exercise']['name']);
  }
}
