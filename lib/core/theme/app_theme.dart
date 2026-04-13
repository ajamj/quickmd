import 'package:flutter/material.dart';

/// App theme configuration with Material 3 support
class AppTheme {
  /// Light theme configuration
  static ThemeData get lightTheme => ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
        useMaterial3: true,
      );

  /// Dark theme configuration
  static ThemeData get darkTheme => ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      );

  /// AMOLED dark theme
  static ThemeData get amoledDarkTheme => ThemeData(
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ).copyWith(
        scaffoldBackgroundColor: Colors.black,
        canvasColor: Colors.black,
        cardColor: Colors.grey[900],
        dialogBackgroundColor: Colors.grey[900],
      );
}
