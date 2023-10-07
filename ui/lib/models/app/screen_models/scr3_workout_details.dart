import 'dart:math';

import '../../../utils/dates.dart';

class Scr3WorkoutDetails {
  final String workoutId;
  final String name;
  final int? dayOfWeek;
  final String? note;
  final List<Scr3Exercise> exercises;
  final List<Scr3CompletedWorkout> completedWorkouts;

  Scr3WorkoutDetails({
    required this.workoutId,
    required this.name,
    this.dayOfWeek,
    this.note,
    required this.exercises,
    required this.completedWorkouts,
  });

  get dayOfWeekName => getDayOfWeekName(dayOfWeek);

  factory Scr3WorkoutDetails.fromJson(Map<String, dynamic> json) {
    return scr3WorkoutDetailsFromJson(json);
  }
}

class Scr3Exercise {
  final String exerciseId;
  final String name;
  final String? note;
  final int setsCount;
  final int maxReps;
  final int totalReps;
  final double? minWeight;
  final double? maxWeight;
  final int? maxRest;
  final double? totalVolume;
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
    this.totalVolume,
    required this.sets,
  });

  factory Scr3Exercise.fromJson(Map<String, dynamic> json) {
    return scr3ExerciseFromJson(json);
  }
}

class Scr3CompletedWorkout {
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
    return scr3CompletedWorkoutFromJson(json);
  }
}

class Scr3Set {
  final int setNumber;
  final int reps;
  final double? weight;
  final String? weightText;
  final Map<int, double>? weightAdjustments;
  final String? note;

  Scr3Set({
    required this.setNumber,
    required this.reps,
    this.weight,
    this.weightText,
    this.weightAdjustments,
    this.note,
  });

  factory Scr3Set.fromJson(Map<String, dynamic> json) {
    return scr3setsFromJson(json);
  }
}

Scr3WorkoutDetails scr3WorkoutDetailsFromJson(Map<String, dynamic> json) {
  var workout = json['wpt_workouts_by_pk'];

  return Scr3WorkoutDetails(
    workoutId: workout['workout_id'],
    name: workout['name'],
    dayOfWeek: workout['day_of_week'] as int?,
    note: workout['note'],
    exercises: (workout['wpt_workout_exercises'] as List)
        .map((e) => Scr3Exercise.fromJson(e))
        .toList(),
    completedWorkouts: (workout['wpt_completed_workouts'] as List)
        .map((e) => Scr3CompletedWorkout.fromJson(e))
        .toList(),
  );
}

Scr3Exercise scr3ExerciseFromJson(Map<String, dynamic> json) {
  List<int> repsList = [];
  List<double> volumeList = [];
  List<int> restTimeBeforeList = [];

  double totalVolume = 0.0;
  int maxReps = 0;
  double? minWeight;
  double maxWeight = 0.0;
  int totalReps = 0;
  int maxRest = 0;

  for (var setRef in json['wpt_set_references']) {
    var details = setRef['wpt_set_details']?.isNotEmpty == true
        ? setRef['wpt_set_details'][0]
        : null;

    if (details != null) {
      int reps = details['rep_count'];
      double? weight = (details['weight'] as num?)?.toDouble();
      int? restTimeBefore = details['rest_time_before'];

      repsList.add(reps);
      totalReps += reps;
      maxReps = max(maxReps, reps);

      if (weight != null) {
        minWeight ??= weight;
        minWeight = min(minWeight, weight);
        maxWeight = max(maxWeight, weight);

        double volume = double.parse((reps * weight).toStringAsFixed(1));
        volumeList.add(volume);
        totalVolume += volume;
      }

      if (restTimeBefore != null) {
        restTimeBeforeList.add(restTimeBefore);
        maxRest = max(maxRest, restTimeBefore);
      }
    }
  }

  return Scr3Exercise(
    exerciseId: json['wpt_exercise']['exercise_id'],
    name: json['wpt_exercise']['name'],
    note: json['wpt_exercise']['note'],
    setsCount: json['wpt_set_references'].length,
    maxReps: maxReps,
    totalReps: totalReps,
    minWeight:
        minWeight != null ? double.parse(minWeight.toStringAsFixed(1)) : null,
    maxWeight: double.parse(maxWeight.toStringAsFixed(1)),
    maxRest: maxRest,
    totalVolume: double.parse(totalVolume.toStringAsFixed(1)),
    sets: (json['wpt_set_references'] as List)
        .map((e) => Scr3Set.fromJson(e))
        .toList(),
  );
}

Scr3CompletedWorkout scr3CompletedWorkoutFromJson(Map<String, dynamic> json) {
  return Scr3CompletedWorkout(
    completedWorkoutId: json['completed_workout_id'],
    startedAt: json['started_at'],
    note: json['note'],
    isActive: json['is_active'],
    completedRepsAmount: json['wpt_completed_sets_aggregate']['aggregate']
            ['completedRepsAmount'] ??
        0,
  );
}

Scr3Set scr3setsFromJson(Map<String, dynamic> json) {
  return Scr3Set(
      setNumber: json['order_number'] + 1,
      reps: json['wpt_set_details'][0]['rep_count'],
      weight: json['wpt_set_details'][0]['weight'] != null
          ? double.parse((json['wpt_set_details'][0]['weight'] as num)
              .toDouble()
              .toStringAsFixed(1))
          : null,
      weightText: json['wpt_set_details'][0]['weight_text'],
      weightAdjustments: json['wpt_set_details'][0]['weight_adjustments'],
      note: _buildNote(
        json['note'],
        json['wpt_set_details'][0]['note'],
      ));
}

String? _buildNote(String? refNote, String? detailNote) {
  if (refNote == null && detailNote == null) {
    return null;
  }

  if (refNote == null) {
    return detailNote;
  }

  if (detailNote == null) {
    return refNote;
  }

  return '$refNote\n$detailNote';
}
