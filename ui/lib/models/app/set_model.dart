import 'exercise_model.dart';

class AppSetModel {
  final int setId;
  final int exerciseId;
  final int? orderNumber;
  final int repCount;
  final double? weight;
  final String? weightText;
  final Map<String, dynamic>? weightAdjustment;
  final String? note;
  final AppExerciseModel exercise;

  AppSetModel({
    required this.setId,
    required this.exerciseId,
    this.orderNumber,
    required this.repCount,
    this.weight,
    this.weightText,
    this.weightAdjustment,
    this.note,
    required this.exercise,
  });

  factory AppSetModel.fromMap(Map<String, dynamic> map) {
    return AppSetModel(
      setId: map['setId'],
      exerciseId: map['exerciseId'],
      orderNumber: map['orderNumber'],
      repCount: map['repCount'],
      weight: map['weight'],
      weightText: map['weightText'],
      weightAdjustment: map['weightAdjustment'],
      note: map['note'],
      exercise: map['exercise'],
    );
  }

  static List<AppSetModel> fromMapList(List<Map<String, dynamic>> maps) {
    return maps.map((map) => AppSetModel.fromMap(map)).toList();
  }

  Map<String, dynamic> toMap() {
    return {
      'setId': setId,
      'exerciseId': exerciseId,
      'orderNumber': orderNumber,
      'repCount': repCount,
      'weight': weight,
      'weightText': weightText,
      'weightAdjustment': weightAdjustment,
      'note': note,
      'exercise': exercise,
    };
  }
}