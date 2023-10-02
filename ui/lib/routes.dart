import 'package:flutter/widgets.dart';

import 'screens/app/workout_form_screen.dart';
import 'screens/app/workout_screen.dart';
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
  '/app/workouts': (context) => AppWorkoutScreen(),
  '/app/workouts/create': (context) => const AppWorkoutFormScreen(),
};
