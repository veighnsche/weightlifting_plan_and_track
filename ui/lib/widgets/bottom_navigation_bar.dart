import 'dart:math';

import 'package:flutter/material.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;

  const AppBottomNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

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
      currentIndex: selectedIndex,
      // set currentIndex to _selectedIndex
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          label: 'Workouts',
        ),
        BottomNavigationBarItem(
          icon: Transform.rotate(
            angle: (3/8) * 2 * pi,
            child: const Icon(Icons.fitness_center)
          ),
          label: 'Exercises',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.check),
          label: 'Completed',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ],
      onTap: (index) {
        if (index != selectedIndex) {
          onItemSelected(index);
        }
      },
    );
  }
}
