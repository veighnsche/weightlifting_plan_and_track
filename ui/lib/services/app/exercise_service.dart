import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

import '../../models/app/exercise_model.dart';
import '../../models/app/screens/exercise_list.dart';
import '../api_service.dart';
import '../graphql_service.dart';

class AppExerciseService {
  final ApiService _apiService = ApiService();
  final GraphQLService _graphQLService = GraphQLService();

  Stream<Scr2ExerciseList> subscribeToExerciseListScreen() {
    // language=GraphQL
    const String getExercisesSubscription = r"""
      subscription GetExercises {
        wpt_exercises {
          exercise_id
          name
          note
          workouts: wpt_workout_exercises {
            wpt_workout {
              name
              day_of_week
            }
            wpt_set_references(limit: 1, order_by: {wpt_set_details_aggregate: {max: {weight: desc}}}) {
              wpt_set_details(order_by: {created_at: desc}, limit: 1) {
                workingWeight: weight
              }
            }
          }
          wpt_completed_sets_aggregate {
            aggregate {
              max {
                personalRecord: weight
              }
            }
          }
        }
      }
    """;
    // language=None

    return _graphQLService
        .subscribe(
      SubscriptionOptions(document: gql(getExercisesSubscription)),
    )
        .map((QueryResult<Object?> queryResult) {
      if (queryResult.hasException) {
        if (kDebugMode) {
          print("error ${queryResult.exception}");
        }
        throw queryResult.exception!;
      }

      return Scr2ExerciseList.fromJson(queryResult.data!);
    });
  }

  Future<AppExerciseModel?> upsert(Map<String, dynamic> exercise) async {
    try {
      final response = await _apiService.post(
        'http://localhost:3000/app/exercises',
        {
          'exercise': exercise,
        },
      );

      print(response.statusCode);
      print(json.decode(response.body));

      if (response.statusCode == 200) {
        return AppExerciseModel.fromMap(json.decode(response.body)['exercise']);
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
    return null;
  }
}
