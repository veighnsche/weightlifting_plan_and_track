import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.transparent,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blueGrey,
      unselectedItemColor: Colors.blueGrey.withOpacity(0.5),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      elevation: 0,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          label: 'Workouts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.fitness_center),
          label: 'Exercises',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check),
          label: 'Completed',
        ),
      ],
      onTap: (index) {
        final routes = [
          '/app/workouts',
          '/app/exercises',
          '/app/completed',
        ];

        if (index < routes.length) {
          String currentRoute = ModalRoute.of(context)?.settings.name ?? '';
          if (currentRoute != routes[index]) {
            Navigator.pushReplacementNamed(context, routes[index]);
          }
        }
      },
    );
  }
}
