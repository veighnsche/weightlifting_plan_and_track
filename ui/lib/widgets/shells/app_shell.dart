import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../bottom_navigation_bar.dart';
import '../chat/chat_sheet.dart';
import '../drawer_content.dart';

class AppShell extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final AppBottomNavigationBar? bottomNavigationBar;

  const AppShell({
    super.key,
    required this.body,
    required this.selectedIndex,
    this.bottomNavigationBar,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isBottomSheetOpen = false;

  void _showBottomSheet() {
    String name = routeNames[widget.selectedIndex];
    Provider.of<ChatProvider>(context, listen: false)
        .newChat("Chatting about $name");

    _scaffoldKey.currentState!
        .showBottomSheet((context) {
          return const ChatSheet();
        })
        .closed
        .then((value) {
          // This callback is called when the bottom sheet is closed
          setState(() {
            _isBottomSheetOpen = false;
          });
        });

    // Update the state to reflect that the bottom sheet is open
    setState(() {
      _isBottomSheetOpen = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(routeNames[widget.selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(
                  context, '${routePaths[widget.selectedIndex]}/create');
            },
          ),
        ],
      ),
      drawer: const Drawer(child: DrawerContent()),
      body: widget.body,
      bottomNavigationBar:
          !_isBottomSheetOpen ? widget.bottomNavigationBar : null,
      floatingActionButton: !_isBottomSheetOpen
          ? FloatingActionButton(
              onPressed: () => _showBottomSheet(),
              child: const Icon(Icons.chat),
            )
          : null,
    );
  }
}

List<String> routeNames = [
  'Workouts',
  'Exercises',
  'Completed workouts',
  'Search Results',
];

List<String> routePaths = [
  '/app/workouts',
  '/app/exercises',
  '/app/completed',
  '/app/search',
];
