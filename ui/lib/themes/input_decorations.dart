import 'package:flutter/material.dart';

InputDecoration blueInputDecoration({required String label, IconData? icon}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: icon != null ? Icon(icon, color: Colors.blueGrey) : null,
    border: const OutlineInputBorder(),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueGrey),
    ),
  );
}
