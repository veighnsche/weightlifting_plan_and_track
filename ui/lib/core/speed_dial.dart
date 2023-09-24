import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class AppSpeedDial extends StatelessWidget {
  final Function(Map<String, dynamic> arguments) showBottomSheet;

  const AppSpeedDial({
    super.key,
    required this.showBottomSheet,
  });

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      backgroundColor: Colors.blueGrey,
      icon: Icons.chat,
      activeIcon: Icons.close,
      elevation: 8.0,
      curve: Curves.bounceIn,
      tooltip: 'Quick Actions',
      children: [
        SpeedDialChild(
          child: const Icon(Icons.track_changes),
          backgroundColor: Colors.green,
          label: 'Start Tracking',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          onTap: () {
            Navigator.pushNamed(context, '/chat', arguments: {
              'mode': 'track',
            });
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.assistant),
          backgroundColor: Colors.orange,
          label: 'Chat about Workouts',
          labelStyle: const TextStyle(fontWeight: FontWeight.w500),
          onTap: () {
            showBottomSheet({
              'mode': 'chat',
            });
          },
        ),
      ],
    );
  }
}
