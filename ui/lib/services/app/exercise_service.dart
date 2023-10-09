import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:weightlifting_plan_and_track/models/app/screen_models/scr4_exercise_details.dart';

import '../../models/app/screen_models/scr2_exercise_list.dart';
import '../api_service.dart';
import '../graphql_service.dart';

class AppExerciseService {
  final ApiService _apiService = ApiService();
  final GraphQLServiceDeprecated _graphQLServiceDeprecated = GraphQLServiceDeprecated();

  Stream<Scr2ExerciseList> exerciseListSubscription() {
    // language=GraphQL
    const String getExercisesSubscription = r"""
      subscription GetExercises {
        wpt_exercises(order_by: {wpt_workout_exercises_aggregate: {avg: {order_number: asc}}}) {
          exercise_id
          name
          note
          wpt_completed_sets_aggregate {
            aggregate {
              max {
                personalRecord: weight
              }
            }
          }
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
        }
      }
    """;
    // language=None

    return _graphQLServiceDeprecated
        .subscribeDeprecated(
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

  Stream<Scr4ExerciseDetails> exerciseDetailsSubscription(String exerciseId) {
    // language=GraphQL
    const String getExerciseDetailsSubscription = r"""
      subscription GetExerciseDetails($exerciseId: uuid!) {
        wpt_exercises_by_pk(exercise_id: $exerciseId) {
          name
          note
          wpt_workout_exercises {
            note
            wpt_workout {
              name
              note
              day_of_week
              workout_id
            }
          }
          wpt_completed_sets(order_by: {completed_at: desc}) {
            completed_at
            rep_count
            weight
            weight_text
            weight_adjustment
            rest_time_before
            note
            wpt_set_detail {
              rep_count
              note
              weight
              weight_adjustment
              weight_text
              rest_time_before
              wpt_set_reference {
                note
              }
            }
            wpt_completed_workout {
              completed_workout_id
              started_at
              wpt_workout {
                name
              }
            }
          }
        }
      }
    """;
    // language=None

    return _graphQLServiceDeprecated
        .subscribeDeprecated(
      SubscriptionOptions(
        document: gql(getExerciseDetailsSubscription),
        variables: {
          'exerciseId': exerciseId,
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

      return Scr4ExerciseDetails.fromJson(queryResult.data!);
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
