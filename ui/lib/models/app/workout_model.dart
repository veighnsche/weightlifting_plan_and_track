import 'exercise_model.dart';

class AppWorkoutModel {
  final String workoutId;
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
      workoutId: map['workout_id'],
      name: map['name'],
      dayOfWeek: map['day_of_week'] == null
          ? null
          : int.parse(map['day_of_week'].toString()),
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
      'workout_id': workoutId,
      'name': name,
      'day_of_week': dayOfWeek,
      'note': note,
      'exercises': exercises,
    };
  }
}
