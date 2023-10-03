import 'package:flutter/material.dart';

final ThemeData chatAppThemeDark = ThemeData(
  primarySwatch: Colors.blueGrey,
  brightness: Brightness.dark,
  visualDensity: VisualDensity.adaptivePlatformDensity,

  // AppBar customization
  appBarTheme: AppBarTheme(
    elevation: 0.0,
    iconTheme: IconThemeData(color: Colors.blueGrey[200]),
    toolbarTextStyle: TextStyle(
      color: Colors.blueGrey[200],
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    ),
    titleTextStyle: TextStyle(
      color: Colors.blueGrey[200],
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
    ),
  ),

  // Text customization for general readability
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Colors.blueGrey[300],
      fontSize: 16.0,
    ),
    bodyMedium: TextStyle(
      color: Colors.blueGrey[200],
    ),
  ),

  // Button theming
  buttonTheme: ButtonThemeData(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    buttonColor: Colors.blueGrey[700],
    textTheme: ButtonTextTheme.primary,
  ),

  // Input fields like TextField or TextFormField
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.blueGrey[800],
    contentPadding: const EdgeInsets.all(12.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.blueGrey[500]),
  ),

  // Icon customization
  iconTheme: IconThemeData(
    color: Colors.blueGrey[400],
    size: 24.0,
  ),

  // Snackbar, for notifications or minor alerts
  snackBarTheme: SnackBarThemeData(
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.blueGrey[900],
    contentTextStyle: TextStyle(color: Colors.blueGrey[200]),
    actionTextColor: Colors.blueGrey[800],
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
    space: 0.5,
    thickness: 1,
    color: Colors.blueGrey[600],
  ),
);
