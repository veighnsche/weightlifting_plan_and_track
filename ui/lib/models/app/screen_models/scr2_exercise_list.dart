import '../../../utils/dates.dart';

class Scr2ExerciseList {
  final List<Scr2ExerciseItem> exercises;

  Scr2ExerciseList({required this.exercises});

  factory Scr2ExerciseList.fromJson(Map<String, dynamic> json) {
    List<Scr2ExerciseItem> unsortedWorkouts = (json['wpt_exercises'] as List)
        .map((data) => Scr2ExerciseItem.fromJson(data))
        .toList();

    return Scr2ExerciseList(exercises: unsortedWorkouts);
  }

  bool get isEmpty => exercises.isEmpty;
}

class Scr2ExerciseItem {
  final String exerciseId;
  final String name;
  final String? note;
  final int? personalRecord;
  final List<Scr2WorkoutItem> workouts;

  Scr2ExerciseItem({
    required this.exerciseId,
    required this.name,
    this.note,
    this.personalRecord,
    required this.workouts,
  });

  factory Scr2ExerciseItem.fromJson(Map<String, dynamic> json) {
    return Scr2ExerciseItem(
        exerciseId: json['exercise_id'],
        name: json['name'],
        note: json['note'],
        personalRecord: json['wpt_completed_sets_aggregate']['aggregate']['max']
            ['personalRecord'],
        workouts: (json['workouts'] as List)
            .map((e) => Scr2WorkoutItem.fromJson(e))
            .toList()
          ..sort(sortByDayOfWeek));
  }
}

class Scr2WorkoutItem {
  final String name;
  final int? dayOfWeek;
  final int? workingWeight;

  Scr2WorkoutItem({
    required this.name,
    this.dayOfWeek,
    this.workingWeight,
  });

  get dayOfWeekName => getDayOfWeekName(dayOfWeek);

  factory Scr2WorkoutItem.fromJson(Map<String, dynamic> json) {
    int? workingWeight;

    if (json['wpt_set_references'] != null &&
        json['wpt_set_references'].isNotEmpty &&
        json['wpt_set_references'][0]['wpt_set_details'] != null &&
        json['wpt_set_references'][0]['wpt_set_details'].isNotEmpty) {
      workingWeight =
          json['wpt_set_references'][0]['wpt_set_details'][0]['workingWeight'];
    }

    return Scr2WorkoutItem(
      name: json['wpt_workout']['name'],
      dayOfWeek: json['wpt_workout']['day_of_week'],
      workingWeight: workingWeight,
    );
  }
}
