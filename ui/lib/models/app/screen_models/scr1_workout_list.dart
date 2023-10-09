import '../../../utils/dates.dart';

class Scr1WorkoutList {
  final List<Scr1WorkoutItem> workouts;

  Scr1WorkoutList({required this.workouts});

  factory Scr1WorkoutList.fromJson(Map<String, dynamic> json) {
    List<Scr1WorkoutItem> workouts = (json['scr1WorkoutList'] as List)
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
    return Scr1WorkoutItem(
      workoutId: json['workout_id'],
      name: json['name'],
      dayOfWeek: json['day_of_week'],
      note: json['note'],
      exercises: (json['exercises'] as List).cast<String>(),
      totalExercises: json['totalExercises'],
      totalSets: json['totalSets'],
    );
  }
}
