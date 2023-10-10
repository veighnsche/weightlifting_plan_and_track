import '../../../utils/dates.dart';
import 'abstract.dart';

class Scr3WorkoutDetails extends ScreenModel {
  final String workoutId;
  final String name;
  final int? dayOfWeek;
  final String? note;
  final int totalExercises;
  final int totalSets;
  final num totalVolume;
  final int totalTime;
  final List<Scr3Exercise> exercises;
  final List<Scr3CompletedWorkout> completedWorkouts;

  Scr3WorkoutDetails({
    required this.workoutId,
    required this.name,
    this.dayOfWeek,
    this.note,
    required this.totalExercises,
    required this.totalSets,
    required this.totalVolume,
    required this.totalTime,
    required this.exercises,
    required this.completedWorkouts,
  });

  get dayOfWeekName => getDayOfWeekName(dayOfWeek);

  factory Scr3WorkoutDetails.fromJson(Map<String, dynamic> json) {
    return Scr3WorkoutDetails(
      workoutId: json['workout_id'],
      name: json['name'],
      dayOfWeek: json['day_of_week'],
      note: json['note'],
      totalExercises: json['total_exercises'],
      totalSets: json['total_sets'],
      totalVolume: json['total_volume'],
      totalTime: json['total_time'],
      exercises: (json['exercises'] as List)
          .map((e) => Scr3Exercise.fromJson(e))
          .toList(),
      completedWorkouts: (json['completed_workouts'] as List)
          .map((cw) => Scr3CompletedWorkout.fromJson(cw))
          .toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'workout_id': workoutId,
      'name': name,
      'day_of_week': dayOfWeek,
      'note': note,
      'total_exercises': totalExercises,
      'total_sets': totalSets,
      'total_volume': totalVolume,
      'total_time': totalTime,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
      'completed_workouts': completedWorkouts.map((cw) => cw.toJson()).toList(),
    };
  }
}

class Scr3Exercise extends ScreenModel {
  final String exerciseId;
  final String name;
  final String? note;
  final int setsCount;
  final int maxReps;
  final int totalReps;
  final num? minWeight;
  final num? maxWeight;
  final int? maxRest;
  final int totalTime;
  final num? totalVolume;
  final List<Scr3Set> sets;

  Scr3Exercise({
    required this.exerciseId,
    required this.name,
    this.note,
    required this.setsCount,
    required this.maxReps,
    required this.totalReps,
    this.minWeight,
    this.maxWeight,
    this.maxRest,
    required this.totalTime,
    this.totalVolume,
    required this.sets,
  });

  factory Scr3Exercise.fromJson(Map<String, dynamic> json) {
    return Scr3Exercise(
      exerciseId: json['exercise_id'],
      name: json['name'],
      note: json['note'],
      setsCount: json['sets_count'],
      maxReps: json['max_reps'],
      totalReps: json['total_reps'],
      minWeight: json['min_weight'],
      maxWeight: json['max_weight'],
      maxRest: json['max_rest'],
      totalTime: json['total_time'],
      totalVolume: json['total_volume'],
      sets: (json['sets'] as List).map((s) => Scr3Set.fromJson(s)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'exercise_id': exerciseId,
      'name': name,
      'note': note,
      'sets_count': setsCount,
      'max_reps': maxReps,
      'total_reps': totalReps,
      'min_weight': minWeight,
      'max_weight': maxWeight,
      'max_rest': maxRest,
      'total_time': totalTime,
      'total_volume': totalVolume,
      'sets': sets.map((set) => set.toJson()).toList(),
    };
  }
}

class Scr3CompletedWorkout extends ScreenModel {
  final String completedWorkoutId;
  final String startedAt;
  final String? note;
  final bool isActive;
  final int completedRepsAmount;

  Scr3CompletedWorkout({
    required this.completedWorkoutId,
    required this.startedAt,
    required this.note,
    required this.isActive,
    required this.completedRepsAmount,
  });

  factory Scr3CompletedWorkout.fromJson(Map<String, dynamic> json) {
    return Scr3CompletedWorkout(
      completedWorkoutId: json['completed_workout_id'],
      startedAt: json['started_at'],
      note: json['note'],
      isActive: json['is_active'],
      completedRepsAmount: json['completed_reps_amount'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'completed_workout_id': completedWorkoutId,
      'started_at': startedAt,
      'note': note,
      'is_active': isActive,
      'completed_reps_amount': completedRepsAmount,
    };
  }
}

class Scr3Set extends ScreenModel {
  final int setNumber;
  final int reps;
  final num? weight;
  final String? weightText;
  final Map<int, double>? weightAdjustments;
  final int? restTimeBefore;
  final String? note;

  Scr3Set({
    required this.setNumber,
    required this.reps,
    this.weight,
    this.weightText,
    this.weightAdjustments,
    this.restTimeBefore,
    this.note,
  });

  factory Scr3Set.fromJson(Map<String, dynamic> json) {
    return Scr3Set(
      setNumber: json['set_number'],
      reps: json['reps'],
      weight: json['weight'],
      weightText: json['weight_text'],
      weightAdjustments: (json['weight_adjustments'] as Map?)
          ?.map((key, value) => MapEntry(int.parse(key), value)),
      restTimeBefore: json['rest_time_before'],
      note: json['note'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'set_number': setNumber,
      'reps': reps,
      'weight': weight,
      'weight_text': weightText,
      'weight_adjustments': weightAdjustments
          ?.map((key, value) => MapEntry(key.toString(), value)),
      'rest_time_before': restTimeBefore,
      'note': note,
    };
  }
}
