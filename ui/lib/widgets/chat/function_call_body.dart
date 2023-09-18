import 'package:flutter/material.dart';

import '../../utils/strings.dart';

class FunctionCallBody extends StatelessWidget {
  final Map<String, dynamic> parameters;
  final List<String>? properties;

  FunctionCallBody({
    required this.parameters,
    this.properties,
  });

  @override
  Widget build(BuildContext context) {
    List<TextSpan> spans = [];

    // Existing code to process properties
    if (properties != null) {
      for (var property in properties!) {
        if (parameters.containsKey(property)) {
          spans.add(
            TextSpan(
              text: "${camelCaseToSpaceCase(property)}:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
          spans.add(
            TextSpan(text: ' ${parameters[property].toString()}'),
          );
        } else {
          spans.add(
            TextSpan(
              text: property,
              style: const TextStyle(color: Colors.grey),
            ),
          );
          spans.add(
            const TextSpan(text: ' -'),
          );
        }
        spans.add(
          const TextSpan(text: '; '),
        );
      }
    }

    // New code to process deprecated parameters
    for (var key in parameters.keys) {
      if (properties == null || !properties!.contains(key)) {
        spans.add(
          TextSpan(
            text: "${camelCaseToSpaceCase(key)}:",
            style: TextStyle(
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        );
        spans.add(
          TextSpan(text: ' ${parameters[key].toString()}'),
        );
        spans.add(
          const TextSpan(text: '; '),
        );
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: spans,
        ),
      ),
    );
  }
}
