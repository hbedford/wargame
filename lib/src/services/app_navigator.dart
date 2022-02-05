import 'package:flutter/cupertino.dart';
import 'package:wargame/src/app.dart';

class AppNavigator {
  AppNavigator._();

  static pushNamed(String route) =>
      Navigator.of(navigationApp.currentContext!).pushNamed(route);
  static pushNameAndRemoveAll(String route) =>
      Navigator.of(navigationApp.currentContext!)
          .pushNamedAndRemoveUntil(route, (_) => false);
  static get pop => Navigator.pop(navigationApp.currentContext!);
}
