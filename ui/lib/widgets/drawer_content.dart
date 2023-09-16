import 'package:flutter/material.dart';

import 'user_profile.dart';
import 'app_logo.dart'; // Assuming you have the AppLogo widget in a separate file named app_logo.dart

class DrawerContent extends StatelessWidget {
  const DrawerContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            children: [
              const DrawerHeader(
                child: AppLogo(iconSize: 60.0, spacing: 10.0, textSize: 18.0),
              ),
              ListTile(
                title: const Text('Chat'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/chat');
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
