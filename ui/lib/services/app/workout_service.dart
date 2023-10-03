import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import '../../models/app/screens/workout_list.dart';
import '../../models/app/workout_model.dart';
import '../api_service.dart';
import '../graphql_service.dart';

class AppWorkoutService {
  final ApiService _apiService = ApiService();
  final GraphQLService _graphQLService = GraphQLService();

  Stream<ScrWorkoutList> subscribeToWorkouts() {
    // language=GraphQL
    const String getWorkoutsSubscription = r"""
      subscription GetWorkouts {
        wpt_workouts {
          workout_id
          name
          day_of_week
          note
          wpt_workout_exercises(limit: 3) {
            wpt_exercise {
              name
            }
          }
          totalExercises: wpt_workout_exercises_aggregate {
            aggregate {
              count
            }
          }
          totalSets: wpt_workout_exercises {
            wpt_set_references_aggregate {
              aggregate {
                count
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

      return ScrWorkoutList.fromJson(queryResult.data!);
    });
  }

  Future<AppWorkoutModel?> upsert(Map<String, dynamic> workout) async {
    try {
      final response = await _apiService.post(
        'http://localhost:3000/app/workouts',
        {
          'workout': workout,
        },
      );

      print(response.statusCode);
      print(json.decode(response.body));

      if (response.statusCode == 200) {
        return AppWorkoutModel.fromMap(json.decode(response.body)['workout']);
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
    return null;
  }
}
