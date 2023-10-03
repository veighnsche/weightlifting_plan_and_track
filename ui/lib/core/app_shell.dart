import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../widgets/chat/chat_sheet.dart';
import '../widgets/drawer_content.dart';
import 'bottom_navigation_bar.dart';

class AppShell extends StatefulWidget {
  final Widget body;
  final int selectedIndex;
  final String? title;
  final List<Widget> actions;
  final bool showBottomNavigationBar;
  final bool showFab;
  final bool showAppBar;
  final PreferredSizeWidget? bottomWidget;
  final AppBottomNavigationBar? bottomNavigationBar;

  const AppShell({
    super.key,
    required this.body,
    required this.selectedIndex,
    this.title,
    this.actions = const [],
    this.showBottomNavigationBar = false,
    this.showFab = false,
    this.showAppBar = true,
    this.bottomWidget,
    this.bottomNavigationBar,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

List<String> routeNames = [
  'Workouts',
  'Exercises',
  'Completed sets',
];

List<String> routePaths = [
  '/app/workouts',
  '/app/exercises',
  '/app/completed',
];

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isBottomSheetOpen = false;

  void _showBottomSheet() {
    String name = routeNames[widget.selectedIndex];

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    chatProvider.newChat("Chatting about $name");

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
      appBar: widget.showAppBar
          ? AppBar(
              title: Text(widget.title ?? routeNames[widget.selectedIndex]),
              actions: [
                ...widget.actions,
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () async {
                    await Navigator.pushNamed(
                        context, '${routePaths[widget.selectedIndex]}/create');
                  },
                ),
              ],
              bottom: widget.bottomWidget,
            )
          : null,
      drawer: const Drawer(child: DrawerContent()),
      body: widget.body,
      bottomNavigationBar: !_isBottomSheetOpen && widget.showBottomNavigationBar
          ? widget.bottomNavigationBar
          : null,
      floatingActionButton: !_isBottomSheetOpen && widget.showFab
          ? FloatingActionButton(
              onPressed: () => _showBottomSheet(),
              child: const Icon(Icons.chat),
            )
          : null,
    );
  }
}
