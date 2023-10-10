import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import '../../models/app/screen_models/scr2_exercise_list.dart';
import '../../models/app/screen_models/scr4_exercise_details.dart';
import '../api_service.dart';
import '../graphql_service.dart';

class AppExerciseService {
  final ApiService _apiService = ApiService();
  final GraphQLService _graphQLService = GraphQLService();

  Future<Stream<Scr2ExerciseList>> scr2exerciseListSubscription() async {
    // language=GraphQL
    const String getExercisesSubscription = r"""
      subscription get_exercises {
          scr2_exercise_list {
              exercise_id
              name
              note
              personal_record
              workouts {
                  name
                  day_of_week
                  working_weight
              }
          }
      }
  """;
    // language=None

    Stream<QueryResult> result = await _graphQLService.subscribe(
      SubscriptionOptions(
        document: gql(getExercisesSubscription),
      ),
    );

    return result.map((QueryResult<Object?> queryResult) {
      if (queryResult.hasException) {
        if (kDebugMode) {
          print("error ${queryResult.exception}");
        }
        throw queryResult.exception!;
      }

      return Scr2ExerciseList.fromJson(queryResult.data!);
    });
  }

  Future<Stream<Scr4ExerciseDetails>> exerciseDetailsSubscription(
      String exerciseId) async {
    // language=GraphQL
    const String getExerciseSubscription = r"""
      subscription get_exercise_details($exercise_id: String!) {
        scr4_exercise_details(exercise_id: $exercise_id) {
          name
          totalCompletedWorkouts
          totalCompletedVolume
          avgDiffInTotalVolume
          note
          workouts {
            workoutId
            name
            note
            dayOfWeek
          }
          completedWorkouts {
            name
            completedWorkoutId
            startedAt
            note
            completedSets
            maxReps
            minWeight
            maxWeight
            avgRestTimeBefore
            completedRepsAmount
            totalVolume
            plannedTotalVolume
            differenceInTotalVolume
          }
        }
      }
    """;
    // language=None

    Stream<QueryResult> result = await _graphQLService.subscribe(
      SubscriptionOptions(
        document: gql(getExerciseSubscription),
        variables: {
          'exercise_id': exerciseId,
        },
      ),
    );

    return result.map((QueryResult<Object?> queryResult) {
      if (queryResult.hasException) {
        if (kDebugMode) {
          print("error ${queryResult.exception}");
        }
        throw queryResult.exception!;
      }

      return Scr4ExerciseDetails.fromJson(
          queryResult.data!['scr4_exercise_details']);
    });
  }

  Future<bool> upsert(Map<String, dynamic> exercise) async {
    try {
      final response = await _apiService.post(
        'http://localhost:3000/app/exercises',
        {
          'exercise': exercise,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        if (kDebugMode) {
          print("error ${response.statusCode} ${response.body}");
        }
        throw Exception('Failed to upsert exercise');
      }
    } catch (error) {
      if (kDebugMode) {
        // explain where we are when the error occurs
        print("error $error, ${StackTrace.current}");
      }
    }
    return false;
  }
}
