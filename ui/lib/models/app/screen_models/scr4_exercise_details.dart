

class Scr4ExerciseDetails {
  String name;
  String note;
  List<Scr4Workout> workouts;
  List<Scr4CompletedWorkout> completedWorkouts;

  Scr4ExerciseDetails({
    required this.name,
    required this.note,
    required this.workouts,
    required this.completedWorkouts,
  });

  factory Scr4ExerciseDetails.fromJson(Map<String, dynamic> json) {
    var exerciseData = json['wpt_exercises_by_pk'];

    // Extracting linked workouts
    List<Scr4Workout> workoutsList = (exerciseData['wpt_workout_exercises']
            as List)
        .map((workoutJson) => Scr4Workout.fromJson(workoutJson['wpt_workout']))
        .toList();

    // Grouping and aggregating completed workouts
    Map<String, List<dynamic>> completedWorkoutsGrouped = {};
    for (var completedSet in exerciseData['wpt_completed_sets']) {
      var workoutId =
          completedSet['wpt_completed_workout']['completed_workout_id'];
      if (completedWorkoutsGrouped[workoutId] == null) {
        completedWorkoutsGrouped[workoutId] = [];
      }
      completedWorkoutsGrouped[workoutId]!.add(completedSet);
    }

    List<Scr4CompletedWorkout> completedWorkoutsList = completedWorkoutsGrouped
        .values
        .map((sets) => Scr4CompletedWorkout.fromSets(sets))
        .toList();

    return Scr4ExerciseDetails(
      name: exerciseData['name'],
      note: exerciseData['note'],
      workouts: workoutsList,
      completedWorkouts: completedWorkoutsList,
    );
  }
}

class Scr4Workout {
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
      workoutId: json['workout_id'],
      name: json['name'],
      note: json['note'],
      dayOfWeek: json['day_of_week'],
    );
  }
}

class Scr4CompletedWorkout {
  String name;
  String completedWorkoutId;
  String startedAt;
  String? note;
  int completedSets;
  int? maxReps;
  double? minWeight;
  double? maxWeight;
  int? avgRestTimeBefore;
  int? completedRepsAmount;
  double? totalVolume;
  double? plannedTotalVolume;
  double? differenceInTotalVolume;

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

  factory Scr4CompletedWorkout.fromSets(List<dynamic> sets) {
    var firstSet = sets[0];
    var totalReps = sets.fold(0, (sum, set) => sum + (set['rep_count'] as int));
    var totalVolume = sets.fold(
        0.0,
        (sum, set) =>
            sum +
            (set['rep_count'] as int) * (set['weight'] as num).toDouble());
    var plannedTotalVolume = sets.fold(
        0.0,
        (sum, set) =>
            sum +
            (set['wpt_set_detail']['rep_count'] as int) *
                (set['wpt_set_detail']['weight'] as num).toDouble());

    return Scr4CompletedWorkout(
      name: firstSet['wpt_completed_workout']['wpt_workout']['name'],
      completedWorkoutId: firstSet['wpt_completed_workout']
          ['completed_workout_id'],
      startedAt: firstSet['wpt_completed_workout']['started_at'],
      note: firstSet['note'],
      completedSets: sets.length,
      maxReps: sets.fold(
          0, (max, set) => set['rep_count'] > max ? set['rep_count'] : max),
      minWeight: sets.fold(
          double.infinity,
          (min, set) => (set['weight'] as num).toDouble() < min!
              ? (set['weight'] as num).toDouble()
              : min),
      maxWeight: sets.fold(
          0.0,
          (max, set) => (set['weight'] as num).toDouble() > max!
              ? (set['weight'] as num).toDouble()
              : max),
      avgRestTimeBefore:
          (sets.fold(0, (sum, set) => sum + (set['rest_time_before'] as int)) /
                  sets.length)
              .round(),
      completedRepsAmount: totalReps,
      totalVolume: totalVolume,
      plannedTotalVolume: plannedTotalVolume,
      differenceInTotalVolume: totalVolume - plannedTotalVolume,
    );
  }
}
