import 'package:flutter/material.dart';
import 'package:wargame/src/cores/app_theme.dart';

class SelectedTheme with ChangeNotifier {
  ThemeData _theme = AppTheme.dark;
  ThemeData get theme => _theme;
  SelectedTheme();
  changeTheme(ThemeData value) {
    _theme = value;
    notifyListeners();
  }
}
