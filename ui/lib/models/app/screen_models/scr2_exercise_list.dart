import 'package:weightlifting_plan_and_track/models/app/screen_models/abstract.dart';

import '../../../utils/dates.dart';

class Scr2ExerciseList extends ScreenModel {
  final List<Scr2ExerciseItem> exercises;

  Scr2ExerciseList({required this.exercises});

  bool get isEmpty => exercises.isEmpty;

  factory Scr2ExerciseList.fromJson(Map<String, dynamic> json) {
    List<Scr2ExerciseItem> exercises = (json['scr2_exercise_list'] as List)
        .map((data) => Scr2ExerciseItem.fromJson(data))
        .toList();

    return Scr2ExerciseList(exercises: exercises);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'scr2_exercise_list': exercises.map((exercise) => exercise.toJson()).toList(),
    };
  }
}

class Scr2ExerciseItem extends ScreenModel {
  final String exerciseId;
  final String name;
  final String? note;
  final double? personalRecord;
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
      personalRecord: (json['personal_record'] is int)
          ? (json['personal_record'] as int).toDouble()
          : json['personal_record'],
      workouts: (json['workouts'] as List)
          .map((e) => Scr2WorkoutItem.fromJson(e))
          .toList()
        ..sort(sortByDayOfWeek),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'name': name,
      'note': note,
      'personal_record': personalRecord,
      'workouts': workouts.map((workout) => workout.toJson()).toList(),
    };
  }
}

class Scr2WorkoutItem extends ScreenModel {
  final String name;
  final int? dayOfWeek;
  final double? workingWeight;

  Scr2WorkoutItem({
    required this.name,
    this.dayOfWeek,
    this.workingWeight,
  });

  get dayOfWeekName => getDayOfWeekName(dayOfWeek);

  factory Scr2WorkoutItem.fromJson(Map<String, dynamic> json) {
    return Scr2WorkoutItem(
      name: json['name'],
      dayOfWeek: json['day_of_week'],
      workingWeight: (json['working_weight'] is int)
          ? (json['working_weight'] as int).toDouble()
          : json['working_weight'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'day_of_week': dayOfWeek,
      'working_weight': workingWeight,
    };
  }
}
