import 'completed_set_model.dart';
import 'set_model.dart';
import 'workout_model.dart';

class AppExerciseModel {
  final int exerciseId;
  final String userUid;
  final String name;
  final String? note;
  final List<AppWorkoutModel> workouts;
  final List<AppSetModel> sets;
  final List<AppCompletedSetModel> completedSets;

  AppExerciseModel({
    required this.exerciseId,
    required this.userUid,
    required this.name,
    this.note,
    required this.workouts,
    required this.sets,
    required this.completedSets,
  });

  factory AppExerciseModel.fromMap(Map<String, dynamic> map) {
    return AppExerciseModel(
      exerciseId: map['exerciseId'],
      userUid: map['userUid'],
      name: map['name'],
      note: map['note'],
      workouts: map['workouts'],
      sets: map['sets'],
      completedSets: map['completedSets'],
    );
  }

  static List<AppExerciseModel> fromMapList(List<Map<String, dynamic>> maps) {
    return maps.map((map) => AppExerciseModel.fromMap(map)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'exerciseId': exerciseId,
      'userUid': userUid,
      'name': name,
      'note': note,
      'workouts': workouts,
      'sets': sets,
      'completedSets': completedSets,
    };
  }
}