import 'package:flutter/material.dart';

List<Widget> addSeparators(Widget separator, List<Widget> items) {
  List<Widget> result = [];
  for (int i = 0; i < items.length; i++) {
    if (i != 0) result.add(separator);
    result.add(items[i]);
  }
  return result;
}
