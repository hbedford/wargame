import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  static ThemeData get light => ThemeData(brightness: Brightness.light);
  static ThemeData get dark => ThemeData(brightness: Brightness.dark);
}
