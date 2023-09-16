import 'package:flutter/material.dart';

import '../widgets/drawer_content.dart';

class AppShell extends StatelessWidget {
  final Widget body;
  final String title;

  const AppShell({
    super.key,
    required this.body,
    this.title = 'Weightlifting Plan and Track',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: const Drawer(child: DrawerContent()),
      body: body,
    );
  }
}
