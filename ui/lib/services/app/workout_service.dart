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

  Stream<Scr1WorkoutList> workoutListSubscription() {
    // language=GraphQL
    const String getWorkoutsSubscription = r"""
        subscription GetWorkouts {
            getWorkouts {
                name
                day_of_week
                note
                workout_id
                exercises
                totalExercises
                totalSets
            }
        }
    """;
    // language=None

    print('workoutListSubscription');

    return _graphQLService
        .subscribe(SubscriptionOptions(
      document: gql(getWorkoutsSubscription),
    ))
        .map((QueryResult<Object?> queryResult) {
      if (queryResult.hasException) {
        if (kDebugMode) {
          print("error ${queryResult.exception}");
        }
        throw queryResult.exception!;
      }

      return Scr1WorkoutList.fromJson(queryResult.data!);
    });
    // mock
  }

  Stream<Scr3WorkoutDetails> workoutDetailsSubscription(String workoutId) {
    // language=GraphQL
    const String getWorkoutSubscription = r"""
      subscription GetWorkoutDetails($workoutId: uuid!) {
        wpt_workouts_by_pk(workout_id: $workoutId) {
          workout_id
          name
          day_of_week
          note
          wpt_workout_exercises(order_by: {order_number: asc}) {
            wpt_exercise {
              exercise_id
              name
              note
            }
            wpt_set_references(order_by: {order_number: asc}) {
              order_number
              note
              wpt_set_details(order_by: {created_at: desc}, limit: 1) {
                rep_count
                weight
                weight_text
                weight_adjustment
                rest_time_before
                note
              }
            }
          }
          wpt_completed_workouts(order_by: {started_at: desc}) {
            completed_workout_id
            started_at
            note
            is_active
            wpt_completed_sets_aggregate {
              aggregate {
                completedRepsAmount: count
              }
            }
          }
        }
      }
    """;
    // language=None

    return _graphQLService
        .subscribeDeprecated(
      SubscriptionOptions(
        document: gql(getWorkoutSubscription),
        variables: <String, dynamic>{
          'workoutId': workoutId,
        },
      ),
    )
        .map((QueryResult<Object?> queryResult) {
      if (queryResult.hasException) {
        if (kDebugMode) {
          print("error ${queryResult.exception}");
        }
        throw queryResult.exception!;
      }

      return Scr3WorkoutDetails.fromJson(queryResult.data!);
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
