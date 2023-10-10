import 'package:weightlifting_plan_and_track/models/app/screen_models/abstract.dart';

import '../../../utils/dates.dart';

class Scr1WorkoutList extends ScreenModel {
  final List<Scr1WorkoutItem> workouts;

  Scr1WorkoutList({required this.workouts});

  bool get isEmpty => workouts.isEmpty;

  factory Scr1WorkoutList.fromJson(Map<String, dynamic> json) {
    List<Scr1WorkoutItem> workouts = (json['scr1_workout_list'] as List)
        .map((data) => Scr1WorkoutItem.fromJson(data))
        .toList();

    return Scr1WorkoutList(workouts: workouts);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'scr1_workout_list': workouts.map((workout) => workout.toJson()).toList(),
    };
  }
}

class Scr1WorkoutItem extends ScreenModel {
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
      totalExercises: json['total_exercises'],
      totalSets: json['total_sets'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'workout_id': workoutId,
      'name': name,
      'day_of_week': dayOfWeek,
      'note': note,
      'exercises': exercises,
      'total_exercises': totalExercises,
      'total_sets': totalSets,
    };
  }
}
