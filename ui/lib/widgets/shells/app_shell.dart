import 'package:flutter/material.dart';

import '../bottom_navigation_bar.dart';
import '../chat/chat_bottom_sheet.dart';
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
  late final ChatBottomSheet _chatBottomSheet;

  @override
  void initState() {
    super.initState();
    _chatBottomSheet = ChatBottomSheet(
      context: context,
      scaffoldKey: _scaffoldKey,
      onSheetClosed: _handleSheetClosed,
    );
  }

  void _handleSheetClosed() {
    setState(() {
      _isBottomSheetOpen = false;
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
              onPressed: () {
                _chatBottomSheet.show(name: routeNames[widget.selectedIndex]);
                setState(() {
                  _isBottomSheetOpen = true;
                });
              },
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
