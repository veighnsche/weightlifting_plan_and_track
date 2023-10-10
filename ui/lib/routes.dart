import 'package:flutter/widgets.dart';

import 'screens/app/exercise_detail_screen.dart';
import 'screens/app/exercise_form_screen.dart';
import 'screens/app/workout_detail_screen.dart';
import 'screens/app/workout_form_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/history_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/user_details_edit_screen.dart';

Map<String, Widget Function(BuildContext)> routes = {
  '/onboarding': (context) => const OnboardingScreen(),
  '/chat': (context) => const ChatScreen(),
  '/history': (context) => HistoryScreen(),
  '/settings': (context) => const SettingsScreen(),
  '/user/edit': (context) => UserDetailsEditScreen(),
  '/app/workouts/create': (context) {
    final routeArgs = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final initialName = routeArgs?['initialName'] as String?;
    final initialNote = routeArgs?['initialNote'] as String?;
    final initialDayOfWeek = routeArgs?['initialDayOfWeek'] as int?;

    return AppWorkoutFormScreen(
      initialName: initialName,
      initialNote: initialNote,
      initialDayOfWeek: initialDayOfWeek,
    );
  },

  '/app/workouts/:workout_id': (context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final workoutId = routeArgs['workout_id']!;

    return AppWorkoutDetailScreen(workoutId: workoutId);
  },
  '/app/exercises/create': (context) => const AppExerciseFormScreen(),
  '/app/exercises/:exercise_id': (context) {
    final routeArgs =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final exerciseId = routeArgs['exercise_id']!;

    return AppExerciseDetailScreen(exerciseId: exerciseId);
  },
};
