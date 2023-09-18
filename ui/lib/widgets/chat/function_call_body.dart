import 'package:flutter/material.dart';

import '../../utils/strings.dart';

class FunctionCallBody extends StatelessWidget {
  final Map<String, dynamic> parameters;
  final List<String>? properties;

  const FunctionCallBody({
    super.key,
    required this.parameters,
    this.properties,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontFamily: 'Courier New'),
          children: _generateTextSpans(),
        ),
      ),
    );
  }

  List<TextSpan> _generateTextSpans() {
    List<TextSpan> spans = [];

    if (properties != null) {
      spans.addAll(_processProperties());
    }
    spans.addAll(_processDeprecatedParameters());

    return spans;
  }

  List<TextSpan> _processProperties() {
    List<TextSpan> spans = [];
    for (var property in properties!) {
      if (parameters.containsKey(property)) {
        spans.add(_boldTextSpan("${camelCaseToSpaceCase(property)}:"));
        spans.add(_normalTextSpan(' ${parameters[property].toString()}'));
      } else {
        spans.add(_greyTextSpan("${camelCaseToSpaceCase(property)}:"));
        spans.add(const TextSpan(text: ' -'));
      }
      spans.add(const TextSpan(text: '; '));
    }
    return spans;
  }

  List<TextSpan> _processDeprecatedParameters() {
    List<TextSpan> spans = [];
    for (var key in parameters.keys) {
      if (properties == null || !properties!.contains(key)) {
        spans.add(_italicGreyTextSpan("${camelCaseToSpaceCase(key)}:"));
        spans.add(_normalTextSpan(' ${parameters[key].toString()}'));
        spans.add(const TextSpan(text: '; '));
      }
    }
    return spans;
  }

  TextSpan _boldTextSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  TextSpan _normalTextSpan(String text) {
    return TextSpan(text: text);
  }

  TextSpan _greyTextSpan(String text) {
    return TextSpan(
      text: text,
      style: const TextStyle(color: Colors.grey),
    );
  }

  TextSpan _italicGreyTextSpan(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        color: Colors.grey[600],
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
