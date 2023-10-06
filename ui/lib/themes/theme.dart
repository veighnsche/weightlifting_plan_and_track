import 'package:flutter/material.dart';

final ThemeData chatAppTheme = ThemeData(
  primarySwatch: Colors.blueGrey,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,

  // AppBar customization
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    iconTheme: const IconThemeData(color: Colors.white),
    toolbarTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      ),
    ).bodyMedium,

    titleTextStyle: const TextTheme(
      titleLarge: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
      ),
    ).titleLarge,
  ),

  // Text customization for general readability
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.blueGrey[700],
      fontSize: 16.0,
    ),
    bodySmall: TextStyle(
      color: Colors.blueGrey[500],
    ),
  ),

  // Button theming
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    buttonColor: Colors.blueGrey[500],
    textTheme: ButtonTextTheme.primary,
  ),

  // Input fields like TextField or TextFormField
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.blueGrey[100],
    contentPadding: const EdgeInsets.all(12.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.blueGrey[400]),
  ),

  // Icon customization
  iconTheme: IconThemeData(
    color: Colors.blueGrey[600],
    size: 24.0,
  ),

  // Snackbar, for notifications or minor alerts
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.blueGrey[600],
    contentTextStyle: const TextStyle(
      color: Colors.white,
    ),
    actionTextColor: Colors.blueGrey[100],
  ),

  // Some miscellaneous adjustments for cards and dividers
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    elevation: 4.0,
    margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  ),

  dividerTheme: DividerThemeData(
    space: 0,
    thickness: 8.0,
    color: Colors.blueGrey[200],
  ),
);
