import 'exercise_model.dart';

class AppWorkoutModel {
  final int workoutId;
  final String name;
  final int? dayOfWeek;
  final String? note;
  final List<AppExerciseModel> exercises;

  AppWorkoutModel({
    required this.workoutId,
    required this.name,
    this.dayOfWeek,
    this.note,
    this.exercises = const [],
  });

  factory AppWorkoutModel.fromMap(Map<String, dynamic> map) {
    return AppWorkoutModel(
      workoutId: map['workoutId'],
      name: map['name'],
      dayOfWeek: map['dayOfWeek'],
      note: map['note'],
      exercises: map['exercises'] != null
          ? AppExerciseModel.fromMapList(map['exercises'])
          : [],
    );
  }

  static List<AppWorkoutModel> fromMapList(List<dynamic> maps) {
    return maps.map((map) => AppWorkoutModel.fromMap(map)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'workoutId': workoutId,
      'name': name,
      'dayOfWeek': dayOfWeek,
      'note': note,
      'exercises': exercises,
    };
  }
}
