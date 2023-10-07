class Exercise {
  String name;
  String note;
  List<Workout> workouts;
  List<CompletedWorkout> completedWorkouts;

  Exercise({
    required this.name,
    required this.note,
    required this.workouts,
    required this.completedWorkouts,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var exerciseData = json['exercise'];

    // Extracting linked workouts
    List<Workout> workoutsList = (exerciseData['workouts'] as List)
        .map((workoutJson) => Workout.fromJson(workoutJson))
        .toList();

    // Grouping and aggregating completed workouts based on our Python logic
    Map<String, List<dynamic>> completedWorkoutsGrouped = {};
    for (var completedSet in json['completed_workouts']) {
      var workoutId = completedSet['completed_workout_id'];
      if (completedWorkoutsGrouped[workoutId] == null) {
        completedWorkoutsGrouped[workoutId] = [];
      }
      completedWorkoutsGrouped[workoutId]!.add(completedSet);
    }

    List<CompletedWorkout> completedWorkoutsList = completedWorkoutsGrouped
        .values
        .map((sets) => CompletedWorkout.fromSets(sets))
        .toList();

    return Exercise(
      name: exerciseData['name'],
      note: exerciseData['note'],
      workouts: workoutsList,
      completedWorkouts: completedWorkoutsList,
    );
  }
}

class Workout {
  String workoutId;
  String name;
  String? note;
  int? dayOfWeek;

  Workout({
    required this.workoutId,
    required this.name,
    required this.note,
    required this.dayOfWeek,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      workoutId: json['workout_id'],
      name: json['name'],
      note: json['note'],
      dayOfWeek: json['day_of_week'],
    );
  }
}

class CompletedWorkout {
  String name;
  String completedWorkoutId;
  String startedAt;
  String? note;
  bool isActive;
  int completedSets;
  int? maxReps;
  double? minWeight;
  double? maxWeight;
  int? avgRestTimeBefore;
  int? completedRepsAmount;
  double? totalVolume;
  double? plannedTotalVolume;
  double? differenceInTotalVolume;

  CompletedWorkout({
    required this.name,
    required this.completedWorkoutId,
    required this.startedAt,
    this.note,
    required this.isActive,
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

  factory CompletedWorkout.fromSets(List<dynamic> sets) {
    var firstSet = sets[0];
    var totalReps = sets.fold(0, (sum, set) => sum + (set['rep_count'] as int));
    var totalVolume =
        sets.fold(0.0, (sum, set) => sum + set['rep_count'] * set['weight']);
    var plannedTotalVolume = sets.fold(0.0,
        (sum, set) => sum + set['planned_rep_count'] * set['planned_weight']);

    return CompletedWorkout(
      name: firstSet['name'],
      completedWorkoutId: firstSet['completed_workout_id'],
      startedAt: firstSet['started_at'],
      note: firstSet['note'],
      isActive: firstSet['is_active'],
      completedSets: sets.length,
      maxReps: sets.fold(
          0, (max, set) => set['rep_count'] > max ? set['rep_count'] : max),
      minWeight: sets.fold(double.infinity,
          (min, set) => set['weight'] < min ? set['weight'] : min),
      maxWeight:
          sets.fold(0, (max, set) => set['weight'] > max ? set['weight'] : max),
      avgRestTimeBefore: (sets.fold(
                  0, (sum, set) => sum + (set['avg_rest_time_before'] as int)) /
              sets.length)
          .round(),
      completedRepsAmount: totalReps,
      totalVolume: totalVolume,
      plannedTotalVolume: plannedTotalVolume,
      differenceInTotalVolume: totalVolume - plannedTotalVolume,
    );
  }
}
