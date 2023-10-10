import 'package:flutter/material.dart';

import '../../models/app/screen_models/scr1_workout_list.dart';
import '../../services/chat/chat_wpt_store_service.dart';
import 'scr1_grid.dart';

class ChatWptGridWidget extends StatelessWidget {
  final ChatWptStoreService _chatWptStoreService = ChatWptStoreService();

  ChatWptGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    if (!_chatWptStoreService.hasData) {
      return const SizedBox.shrink();
    }

    switch (_chatWptStoreService.dataType) {
      case Scr1WorkoutList:
        return Scr1Grid(workout: _chatWptStoreService.workoutList!);
      // case Scr2ExerciseList:
      //   return Scr2Grid();
      // case Scr3WorkoutDetails:
      //   return Scr3Grid();
      // case Scr4ExerciseDetails:
      //   return Scr4Grid();
      default:
        return const SizedBox.shrink();
    }
  }
}
