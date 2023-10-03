class Scr1WorkoutList {
  final List<Scr1WorkoutItem> workouts;

  Scr1WorkoutList({required this.workouts});

  factory Scr1WorkoutList.fromJson(Map<String, dynamic> json) {
    List<Scr1WorkoutItem> unsortedWorkouts = (json['wpt_workouts'] as List)
        .map((data) => Scr1WorkoutItem.fromJson(data))
        .toList();

    int today = DateTime.now().weekday - 1; // 0 = Monday, 6 = Sunday

    unsortedWorkouts.sort((a, b) {
      // Both are today's workouts or both don't have a dayOfWeek
      if ((a.dayOfWeek == today && b.dayOfWeek == today) || (a.dayOfWeek == null && b.dayOfWeek == null)) {
        return 0;
      }
      // 'a' is today's workout
      if (a.dayOfWeek == today) {
        return -1;
      }
      // 'b' is today's workout
      if (b.dayOfWeek == today) {
        return 1;
      }
      // 'a' doesn't have a dayOfWeek
      if (a.dayOfWeek == null) {
        return 1;
      }
      // 'b' doesn't have a dayOfWeek
      if (b.dayOfWeek == null) {
        return -1;
      }
      // Both have a dayOfWeek but neither is today's workout
      return a.dayOfWeek!.compareTo(b.dayOfWeek!);
    });

    return Scr1WorkoutList(workouts: unsortedWorkouts);
  }

  bool get isEmpty => workouts.isEmpty;
}

class Scr1WorkoutItem {
  final String workoutId;
  final String name;
  final int? dayOfWeek;
  final String? note;
  final List<Scr1ExerciseItem> exercises;
  final int totalExercises;
  final int totalSets;

  Scr1WorkoutItem({
    required this.workoutId,
    required this.name,
    this.dayOfWeek,
    this.note,
    required this.exercises,
    required this.totalExercises,
    required this.totalSets,
  });

  factory Scr1WorkoutItem.fromJson(Map<String, dynamic> json) {
    int getTotalCount(Map<String, dynamic> json, String key) {
      var value = json[key];
      if (value is List) {
        return value.isEmpty ? 0 : value.length; // Assuming you want the length of the list
      } else if (value is Map && value['aggregate'] != null) {
        return value['aggregate']['count'];
      } else {
        throw Exception('Unexpected data format for key: $key');
      }
    }


    return Scr1WorkoutItem(
      workoutId: json['workout_id'],
      name: json['name'],
      dayOfWeek: json['day_of_week'],
      note: json['note'],
      exercises: (json['wpt_workout_exercises'] as List)
          .map((data) => Scr1ExerciseItem.fromJson(data))
          .toList(),
      totalExercises: getTotalCount(json, 'totalExercises'),
      totalSets: getTotalCount(json, 'totalSets'),
    );
  }

}

class Scr1ExerciseItem {
  final String name;

  Scr1ExerciseItem({required this.name});

  factory Scr1ExerciseItem.fromJson(Map<String, dynamic> json) {
    print("ScrExerciseItem.fromJson: $json");

    var exercise = json['wpt_exercise'];
    if (exercise != null && exercise is Map) {
      return Scr1ExerciseItem(name: exercise['name'] ?? '');
    } else {
      // You might want to return a default value or throw a specific error here.
      throw Exception('Exercise data is not properly formatted.');
    }
  }
}
