import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../widgets/chat/chat_sheet.dart';
import '../widgets/drawer_content.dart';
import 'bottom_navigation_bar.dart';

class AppShell extends StatefulWidget {
  final Widget body;
  final String title;
  final List<Widget> actions;
  final bool showBottomNavigationBar;
  final bool showFab;
  final bool showChat;

  const AppShell({
    Key? key,
    required this.body,
    this.title = 'Weightlifting Plan and Track',
    this.actions = const [],
    this.showBottomNavigationBar = false,
    this.showFab = false,
    this.showChat = false,
  }) : super(key: key);

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isBottomSheetOpen = false;

  void _showBottomSheet() {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    Map<String, String> routeNames = {
      '/app/workouts': 'Chatting about workouts',
      '/app/exercises': 'Chatting about exercises',
      '/app/completed': 'Chatting about completed sets',
    };
    String name = routeNames[currentRoute] ?? 'Chatting about workouts';

    final chatProvider = Provider.of<ChatProvider>(context, listen: false);

    chatProvider.newChat(name);

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
        title: Text(widget.title),
        actions: widget.actions,
      ),
      drawer: const Drawer(child: DrawerContent()),
      body: widget.body,
      bottomNavigationBar: !_isBottomSheetOpen && widget.showBottomNavigationBar
          ? const AppBottomNavigationBar()
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
