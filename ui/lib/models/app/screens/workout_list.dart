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
      if ((a.dayOfWeek == today && b.dayOfWeek == today) ||
          (a.dayOfWeek == null && b.dayOfWeek == null)) {
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
  final List<String> exercises;
  final int totalExercises;
  final int totalSets;

  Scr1WorkoutItem({
    required this.workoutId,
    required this.name,
    required this.dayOfWeek,
    required this.note,
    required this.exercises,
    required this.totalExercises,
    required this.totalSets,
  });

  factory Scr1WorkoutItem.fromJson(Map<String, dynamic> json) {
    List<String> exercisesList = (json['wpt_workout_exercises'] as List)
        .map((e) => e['wpt_exercise']['name'] as String)
        .toList();

    int totalSetsCount = (json['totalSetsAggragate'] as List).fold(
        0,
        (sum, item) =>
            sum +
            (item['wpt_set_references_aggregate']['aggregate']['totalSets']
                    as num)
                .toInt());

    return Scr1WorkoutItem(
      workoutId: json['workout_id'],
      name: json['name'],
      dayOfWeek: json['day_of_week'] as int?,
      note: json['note'],
      exercises: exercisesList,
      totalExercises: json['wpt_workout_exercises_aggregate']['aggregate']
          ['totalExercises'],
      totalSets: totalSetsCount,
    );
  }
}
