import '../../../utils/dates.dart';

class Scr1WorkoutList {
  final List<Scr1WorkoutItem> workouts;

  Scr1WorkoutList({required this.workouts});

  factory Scr1WorkoutList.fromJson(Map<String, dynamic> json) {
    List<Scr1WorkoutItem> workouts = (json['wpt_workouts'] as List)
        .map((data) => Scr1WorkoutItem.fromJson(data))
        .toList()
      ..sort(sortByDayOfWeek);

    return Scr1WorkoutList(workouts: workouts);
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
    this.dayOfWeek,
    this.note,
    required this.exercises,
    required this.totalExercises,
    required this.totalSets,
  });

  get dayOfWeekName => getDayOfWeekName(dayOfWeek);

  factory Scr1WorkoutItem.fromJson(Map<String, dynamic> json) {
    List<String> exercisesList = (json['wpt_workout_exercises'] as List)
        .map((e) => e['wpt_exercise']['name'] as String)
        .toList();

    int totalSetsCount =
        (json['totalSetsAggragate'] as List).fold(0, (sum, item) {
      int totalSets = item['wpt_set_references_aggregate']['aggregate']
              ['totalSets']
          .toInt();
      return sum + totalSets;
    });

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
