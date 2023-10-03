import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  _AppBottomNavigationBarState createState() => _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState extends State<AppBottomNavigationBar> {
  int _selectedIndex = 0; // default index is 0

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
      currentIndex: _selectedIndex,
      // set currentIndex to _selectedIndex
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

        setState(() {
          // update the state when a new index is tapped
          _selectedIndex = index;
        });
      },
    );
  }
}
