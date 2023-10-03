import 'package:flutter/material.dart';

import '../widgets/drawer_content.dart';

class ChatShell extends StatefulWidget {
  final Widget body;
  final String title;
  final List<Widget> actions;

  const ChatShell({
    super.key,
    required this.body,
    this.title = 'Weightlifting Plan and Track',
    this.actions = const [],
  });

  @override
  State<ChatShell> createState() => _ChatShellState();
}

class _ChatShellState extends State<ChatShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    );
  }
}
