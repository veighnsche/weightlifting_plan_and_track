import 'package:flutter/material.dart';

InputDecoration blueInputDecoration({required String label, IconData? icon}) {
  return InputDecoration(
    labelText: label,
    labelStyle: TextStyle(
      color: Colors.grey[600],
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
    ),
    prefixIcon: icon != null ? Icon(icon, color: Colors.blueGrey) : null,
    border: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[400]!),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey[400]!, width: 1.0),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
    ),
  );
}
