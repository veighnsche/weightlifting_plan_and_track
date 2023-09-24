import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double iconSize;
  final double spacing;
  final double textSize;

  final String? title;

  const AppLogo({
    super.key,
    this.iconSize = 100.0,
    this.spacing = 20.0,
    this.textSize = 24.0,
    this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.fitness_center, size: iconSize, color: Colors.blueGrey),
        SizedBox(height: spacing),
        Text(
          'Weightlifting Plan & Track',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
            color: Colors.blueGrey,
          ),
        ),
        ...title != null
            ? [
                SizedBox(height: spacing),
                Text(
                  title!,
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: textSize,
                  ),
                )
              ]
            : [],
      ],
    );
  }
}
