import 'package:flutter/material.dart';

import '../../core/app_shell.dart';

class AppWorkoutScreen extends StatelessWidget {
  const AppWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppShell(
      title: 'Workouts',
      showBottomNavigationBar: true,
      showFab: true,
      showChat: true,
      body: Center(
        child: Text('Workouts'),
      ),
    );
  }
}
