import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import 'user_profile.dart';
import 'app_logo.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    final chatProvider = Provider.of<ChatProvider>(context);

    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: [
              const DrawerHeader(
                child: AppLogo(iconSize: 60.0, spacing: 10.0, textSize: 18.0),
              ),
              ListTile(
                title: const Text('New Chat'),
                onTap: () {
                  Navigator.pop(context);
                  chatProvider.newChat();
                },
              ),
              ListTile(
                title: const Text('History'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/history');
                },
              ),
              ListTile(
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ],
          ),
        ),
        UserProfile(),
      ],
    );
  }
}
