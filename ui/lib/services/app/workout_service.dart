import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import '../../models/app/screen_models/scr1_workout_list.dart';
import '../../models/app/screen_models/scr3_workout_details.dart';
import '../api_service.dart';
import '../graphql_service.dart';

class AppWorkoutService {
  final ApiService _apiService = ApiService();
  final GraphQLService _graphQLService = GraphQLService();

  Future<Stream<Scr1WorkoutList>> scr1workoutListSubscription() async {
    // language=GraphQL
    const String getWorkoutsSubscription = r"""
        subscription get_workouts {
            scr1_workout_list {
                name
                day_of_week
                note
                workout_id
                exercises
                total_exercises
                total_sets
            }
        }
    """;
    // language=None

    Stream<QueryResult> result = await _graphQLService.subscribe(
      SubscriptionOptions(
        document: gql(getWorkoutsSubscription),
      ),
    );

    return result.map((QueryResult<Object?> queryResult) {
      if (queryResult.hasException) {
        if (kDebugMode) {
          print("error ${queryResult.exception}");
        }
        throw queryResult.exception!;
      }

      return Scr1WorkoutList.fromJson(queryResult.data!);
    });
  }

  Future<Stream<Scr3WorkoutDetails>> workoutDetailsSubscription(String workoutId) async {
    // language=GraphQL
    const String getWorkoutSubscription = r"""
      subscription get_workout_details($workout_id: String!) {
        scr3_workout_details(workout_id: $workout_id) {
          workout_id
          name
          day_of_week
          note
          total_exercises
          total_sets
          total_volume
          total_time
          exercises {
            exercise_id
            name
            note
            sets_count
            max_reps
            total_reps
            min_weight
            max_weight
            max_rest
            total_time
            total_volume
            sets {
              set_number
              reps
              weight
              weight_text
              weight_adjustments
              rest_time_before
              note
            }
          }
          completed_workouts {
            completed_workout_id
            started_at
            note
            is_active
            completed_reps_amount
          }
        }
      }
    """;
    // language=None

    Stream<QueryResult> result = await _graphQLService.subscribe(
      SubscriptionOptions(
        document: gql(getWorkoutSubscription),
        variables: {
          'workout_id': workoutId,
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

      return Scr3WorkoutDetails.fromJson(queryResult.data!['scr3_workout_details']);
    });
  }

  Future<bool> upsert(Map<String, dynamic> workout) async {
    try {
      final response = await _apiService.post(
        'http://localhost:3000/app/workouts',
        {
          'workout': workout,
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        if (kDebugMode) {
          print("error ${response.statusCode} ${response.body}");
        }
        throw Exception('Failed to upsert workout');
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
