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
    required this.exercises,
  });
  
  factory AppWorkoutModel.fromMap(Map<String, dynamic> map) {
    return AppWorkoutModel(
      workoutId: map['workoutId'],
      name: map['name'],
      dayOfWeek: map['dayOfWeek'],
      note: map['note'],
      exercises: map['exercises'],
    );
  }

  static List<AppWorkoutModel> fromMapList(List<Map<String, dynamic>> maps) {
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





