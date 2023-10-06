import 'package:flutter/material.dart';
import 'package:weightlifting_plan_and_track/widgets/detail_box.dart';

import '../../models/app/screen_models/scr3_workout_details.dart';
import '../../utils/scr3_utils.dart';

class Scr3SetCard extends StatelessWidget {
  final Scr3Set set;

  static const double _detailBoxHeight = 60.0; // Adjust as required
  static const double _paddingSize = 8.0; // Adjust as required

  const Scr3SetCard({Key? key, required this.set}) : super(key: key);

  Widget _buildSetDetails() {
    List<Widget> boxes = [];

    HandleSetDetails(
      setDetails: set,
      addEntry: (String name, String value, IconData iconData) {
        boxes.add(
          DetailBox(name: name, value: value, icon: iconData),
        );
      },
    );

    return SizedBox(
      height: Scr3SetCard._detailBoxHeight,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          const SizedBox(width: Scr3SetCard._paddingSize),
          ...boxes,
          const SizedBox(width: Scr3SetCard._paddingSize),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 8.0),
          _buildSetDetails(),
          const SizedBox(height: 8.0),
          if (set.note != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text('Note: ${set.note}'),
            ),
        ],
      ),
    );
  }
}
