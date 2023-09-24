import 'package:flutter/material.dart';

import '../../core/app_shell.dart';

class AppWorkoutScreen extends StatelessWidget {
  const AppWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShell(
      title: 'Workouts',
      showBottomNavigationBar: true,
      showFab: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/app/workouts/create');
          },
        ),
      ],
      body: const Center(
        child: Text('Workouts'),
      ),
    );
  }
}
