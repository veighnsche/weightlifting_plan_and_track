import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/screens/app/exercise_list_screen.dart';
import 'package:weightlifting_plan_and_track/screens/app/search_screen.dart';
import 'package:weightlifting_plan_and_track/screens/app/workout_list_screen.dart';

import '../../widgets/bottom_navigation_bar.dart';
import '../../widgets/shells/app_shell.dart';
import 'completed_list_screen.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  _AppScreenState createState() => _AppScreenState();
}

class _AppScreenState extends State<AppScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      selectedIndex: _selectedIndex,
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemSelected: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
          );
        },
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          AppWorkoutListScreen(),
          AppExerciseListScreen(),
          CompletedListScreen(),
          SearchScreen(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
