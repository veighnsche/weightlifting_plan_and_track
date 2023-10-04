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
}

class Scr3Exercise {
  final String exerciseId;
  final String name;
  final String? note;
  final int setsCount;
  final int? averageReps;
  final int? highestWeight;

  Scr3Exercise({
    required this.exerciseId,
    required this.name,
    this.note,
    required this.setsCount,
    this.averageReps,
    this.highestWeight,
  });

  factory Scr3Exercise.fromJson(Map<String, dynamic> json) {
    List<int> repsList = [];
    List<int> weightList = [];

    for (var setRef in json['wpt_set_references']) {
      if (setRef['wpt_set_details'] != null &&
          setRef['wpt_set_details'].isNotEmpty) {
        repsList.add(setRef['wpt_set_details'][0]['repsPerSet']);
        weightList.add(setRef['wpt_set_details'][0]['weightPerSet']);
      }
    }

    int avgReps = (repsList.reduce((a, b) => a + b) / repsList.length).round();
    int maxWeight = weightList.reduce((a, b) => a > b ? a : b);

    return Scr3Exercise(
      exerciseId: json['wpt_exercise']['exercise_id'],
      name: json['wpt_exercise']['name'],
      note: json['wpt_exercise']['note'],
      setsCount: json['wpt_set_references'].length,
      averageReps: avgReps,
      highestWeight: maxWeight,
    );
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
    return Scr3CompletedWorkout(
      completedWorkoutId: json['completed_workout_id'],
      startedAt: json['started_at'],
      note: json['note'],
      isActive: json['is_active'],
      completedRepsAmount:
      json['wpt_completed_sets_aggregate']['aggregate']['completedRepsAmount'],
    );
  }
}
