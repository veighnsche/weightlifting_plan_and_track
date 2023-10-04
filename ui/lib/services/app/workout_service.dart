import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import '../../models/app/screen_models/workout_list.dart';
import '../api_service.dart';
import '../graphql_service.dart';

class AppWorkoutService {
  final ApiService _apiService = ApiService();
  final GraphQLService _graphQLService = GraphQLService();

  Stream<Scr1WorkoutList> subscribeToWorkoutListScreen() {
    // language=GraphQL
    const String getWorkoutsSubscription = r"""
      subscription GetWorkouts {
        wpt_workouts {
          workout_id
          name
          day_of_week
          note
          wpt_workout_exercises(limit: 3, order_by: {order_number: asc}) {
            wpt_exercise {
              name
            }
          }
          wpt_workout_exercises_aggregate {
            aggregate {
              totalExercises: count
            }
          }
          totalSetsAggragate: wpt_workout_exercises {
            wpt_set_references_aggregate {
              aggregate {
                totalSets: count
              }
            }
          }
        }
      }
    """;
    // language=None

    return _graphQLService
        .subscribe(
      SubscriptionOptions(document: gql(getWorkoutsSubscription)),
    )
        .map((QueryResult<Object?> queryResult) {
      if (queryResult.hasException) {
        if (kDebugMode) {
          print("error ${queryResult.exception}");
        }
        throw queryResult.exception!;
      }

      return Scr1WorkoutList.fromJson(queryResult.data!);
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
