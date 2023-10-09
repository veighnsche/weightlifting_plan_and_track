import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';
import 'package:weightlifting_plan_and_track/models/app/screen_models/scr4_exercise_details.dart';

import '../../models/app/screen_models/scr2_exercise_list.dart';
import '../api_service.dart';
import '../graphql_service.dart';

class AppExerciseService {
  final ApiService _apiService = ApiService();
  final GraphQLServiceDeprecated _graphQLServiceDeprecated = GraphQLServiceDeprecated();
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
          'exercise_id': exerciseId,
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
