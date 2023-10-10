import 'abstract.dart';

class Scr4ExerciseDetails extends ScreenModel {
  String name;
  int totalCompletedWorkouts;
  double totalCompletedVolume;
  double avgDiffInTotalVolume;
  String? note;
  List<Scr4Workout> workouts;
  List<Scr4CompletedWorkout> completedWorkouts;

  Scr4ExerciseDetails({
    required this.name,
    required this.totalCompletedWorkouts,
    required this.totalCompletedVolume,
    required this.avgDiffInTotalVolume,
    required this.note,
    required this.workouts,
    required this.completedWorkouts,
  });

  factory Scr4ExerciseDetails.fromJson(Map<String, dynamic> json) {
    return Scr4ExerciseDetails(
      name: json['name'],
      totalCompletedWorkouts: json['totalCompletedWorkouts'],
      totalCompletedVolume: json['totalCompletedVolume'].toDouble(),
      avgDiffInTotalVolume: json['avgDiffInTotalVolume'].toDouble(),
      note: json['note'],
      workouts: (json['workouts'] as List)
          .map((workoutJson) => Scr4Workout.fromJson(workoutJson as Map<String, dynamic>))
          .toList(),
      completedWorkouts: (json['completedWorkouts'] as List)
          .map((completedWorkoutJson) => Scr4CompletedWorkout.fromJson(completedWorkoutJson as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalCompletedWorkouts': totalCompletedWorkouts,
      'totalCompletedVolume': totalCompletedVolume,
      'avgDiffInTotalVolume': avgDiffInTotalVolume,
      'note': note,
      'workouts': workouts.map((workout) => workout.toJson()).toList(),
      'completedWorkouts': completedWorkouts.map((cw) => cw.toJson()).toList(),
    };
  }
}

class Scr4Workout extends ScreenModel {
  String workoutId;
  String name;
  String? note;
  int? dayOfWeek;

  Scr4Workout({
    required this.workoutId,
    required this.name,
    this.note,
    this.dayOfWeek,
  });

  factory Scr4Workout.fromJson(Map<String, dynamic> json) {
    return Scr4Workout(
      workoutId: json['workoutId'],
      name: json['name'],
      note: json['note'],
      dayOfWeek: json['dayOfWeek'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'workoutId': workoutId,
      'name': name,
      'note': note,
      'dayOfWeek': dayOfWeek,
    };
  }
}

class Scr4CompletedWorkout extends ScreenModel {
  String name;
  String completedWorkoutId;
  String startedAt;
  String? note;
  int completedSets;
  int maxReps;
  double minWeight;
  double maxWeight;
  double avgRestTimeBefore;
  int completedRepsAmount;
  double totalVolume;
  double plannedTotalVolume;
  double differenceInTotalVolume;

  Scr4CompletedWorkout({
    required this.name,
    required this.completedWorkoutId,
    required this.startedAt,
    this.note,
    required this.completedSets,
    required this.maxReps,
    required this.minWeight,
    required this.maxWeight,
    required this.avgRestTimeBefore,
    required this.completedRepsAmount,
    required this.totalVolume,
    required this.plannedTotalVolume,
    required this.differenceInTotalVolume,
  });

  factory Scr4CompletedWorkout.fromJson(Map<String, dynamic> json) {
    return Scr4CompletedWorkout(
      name: json['name'],
      completedWorkoutId: json['completedWorkoutId'],
      startedAt: json['startedAt'],
      note: json['note'],
      completedSets: json['completedSets'],
      maxReps: json['maxReps'],
      minWeight: json['minWeight'].toDouble(),
      maxWeight: json['maxWeight'].toDouble(),
      avgRestTimeBefore: json['avgRestTimeBefore'].toDouble(),
      completedRepsAmount: json['completedRepsAmount'],
      totalVolume: json['totalVolume'].toDouble(),
      plannedTotalVolume: json['plannedTotalVolume'].toDouble(),
      differenceInTotalVolume: json['differenceInTotalVolume'].toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'completedWorkoutId': completedWorkoutId,
      'startedAt': startedAt,
      'note': note,
      'completedSets': completedSets,
      'maxReps': maxReps,
      'minWeight': minWeight,
      'maxWeight': maxWeight,
      'avgRestTimeBefore': avgRestTimeBefore,
      'completedRepsAmount': completedRepsAmount,
      'totalVolume': totalVolume,
      'plannedTotalVolume': plannedTotalVolume,
      'differenceInTotalVolume': differenceInTotalVolume,
    };
  }
}