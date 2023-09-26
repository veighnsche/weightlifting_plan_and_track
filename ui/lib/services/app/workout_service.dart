import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hasura_connect/hasura_connect.dart';


import '../../models/app/workout_model.dart';
import '../api_service.dart';

class AppWorkoutService {
  final ApiService _apiService = ApiService();

  Future<List<AppWorkoutModel>> getAll() async {
    // try {
    //   final response = await _apiService.get('http://localhost:3000/app/workouts');
    //
    //   if (response.statusCode == 200) {
    //     return AppWorkoutModel.fromMapList(json.decode(response.body)['workouts']);
    //   } else {
    //     throw Exception('Failed to get workouts');
    //   }
    // } catch (error) {
    //   if (kDebugMode) {
    //     print(error);
    //   }
    // }
    return [];
  }

  Future<AppWorkoutModel?> upsert(Map<String, dynamic> workout) async {
    try {
      final response =
          await _apiService.post('http://localhost:3000/app/workouts', {
            'workout': workout,
          });

      if (response.statusCode == 200) {
        return AppWorkoutModel.fromMap(json.decode(response.body)['workout']);
      } else {
        throw Exception('Failed to upsert workout');
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
    }
    return null;
  }
}
