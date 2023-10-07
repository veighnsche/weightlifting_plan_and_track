

class Exercise {
  String name;
  String note;
  List<Workout> workouts;
  List<CompletedWorkout> completedWorkouts;

  Exercise(
      {required this.name,
      required this.note,
      required this.workouts,
      required this.completedWorkouts});

  factory Exercise.fromJson(Map<String, dynamic> json) {
    var exerciseData = json['data']['wpt_exercises_by_pk'];

    return Exercise(
      name: exerciseData['name'],
      note: exerciseData['note'],
      workouts: (exerciseData['wpt_workout_exercises'] as List)
          .map((workoutJson) => Workout.fromJson(workoutJson))
          .toList(),
      completedWorkouts:
          CompletedWorkout.fromList(exerciseData['wpt_completed_sets']),
    );
  }
}

class Workout {
  String workoutId;
  String name;
  String note;
  int dayOfWeek;

  Workout(
      {required this.workoutId,
      required this.name,
      required this.note,
      required this.dayOfWeek});

  factory Workout.fromJson(Map<String, dynamic> json) {
    var workoutData = json['wpt_workout'];

    return Workout(
      workoutId: workoutData['workout_id'],
      name: workoutData['name'],
      note: workoutData['note'],
      dayOfWeek: workoutData['day_of_week'],
    );
  }
}

class CompletedWorkout {
  String completedWorkoutId;
  DateTime startedAt;
  int completedSets;
  int maxReps;
  int minWeight;
  int maxWeight;
  double avgRestTimeBefore;
  int completedRepsAmount;
  int totalVolume;

  CompletedWorkout({
    required this.completedWorkoutId,
    required this.startedAt,
    required this.completedSets,
    required this.maxReps,
    required this.minWeight,
    required this.maxWeight,
    required this.avgRestTimeBefore,
    required this.completedRepsAmount,
    required this.totalVolume,
  });

  static List<CompletedWorkout> fromList(List<dynamic> setDetailsList) {
    Map<String, CompletedWorkout> completedWorkouts = {};

    for (var setDetailJson in setDetailsList) {
      var workoutDetail = setDetailJson['wpt_completed_workout'];
      var workoutId = workoutDetail['completed_workout_id'];

      if (!completedWorkouts.containsKey(workoutId)) {
        completedWorkouts[workoutId] = CompletedWorkout(
          completedWorkoutId: workoutId,
          startedAt: DateTime.parse(workoutDetail['started_at']),
          completedSets: 0,
          maxReps: 0,
          minWeight: 9999999,
          // Placeholder
          maxWeight: 0,
          avgRestTimeBefore: 0,
          completedRepsAmount: 0,
          totalVolume: 0,
        );
      }

      var workout = completedWorkouts[workoutId]!;
      workout.completedSets += 1;
      workout.maxReps = setDetailJson['rep_count'] > workout.maxReps
          ? setDetailJson['rep_count']
          : workout.maxReps;
      workout.minWeight = setDetailJson['weight'] < workout.minWeight
          ? setDetailJson['weight']
          : workout.minWeight;
      workout.maxWeight = setDetailJson['weight'] > workout.maxWeight
          ? setDetailJson['weight']
          : workout.maxWeight;
      workout.avgRestTimeBefore += setDetailJson['rest_time_before'];
      workout.completedRepsAmount += (setDetailJson['rep_count'] as int);
      workout.totalVolume += (setDetailJson['rep_count'] as int) *
          (setDetailJson['weight'] as int);
    }

    // Compute averages
    completedWorkouts.forEach((key, workout) {
      workout.avgRestTimeBefore /= workout.completedSets;
    });

    return completedWorkouts.values.toList();
  }
}
