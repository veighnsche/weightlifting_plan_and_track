import 'exercise_model.dart';

class AppCompletedSetModel {
  final String completedSetId;
  final DateTime completedAt;
  final int exerciseId;
  final int repCount;
  final double? weight;
  final String? weightText;
  final Map<String, dynamic>? weightAdjustment;
  final String? note;
  final AppExerciseModel exercise;

  AppCompletedSetModel({
    required this.completedSetId,
    required this.completedAt,
    required this.exerciseId,
    required this.repCount,
    this.weight,
    this.weightText,
    this.weightAdjustment,
    this.note,
    required this.exercise,
  });

  factory AppCompletedSetModel.fromMap(Map<String, dynamic> map) {
    return AppCompletedSetModel(
      completedSetId: map['completedSetId'],
      completedAt: map['completedAt'],
      exerciseId: map['exerciseId'],
      repCount: map['repCount'],
      weight: map['weight'],
      weightText: map['weightText'],
      weightAdjustment: map['weightAdjustment'],
      note: map['note'],
      exercise: map['exercise'],
    );
  }

  static List<AppCompletedSetModel> fromMapList(List<Map<String, dynamic>> maps) {
    return maps.map((map) => AppCompletedSetModel.fromMap(map)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'completedSetId': completedSetId,
      'completedAt': completedAt,
      'exerciseId': exerciseId,
      'repCount': repCount,
      'weight': weight,
      'weightText': weightText,
      'weightAdjustment': weightAdjustment,
      'note': note,
      'exercise': exercise,
    };
  }
}
