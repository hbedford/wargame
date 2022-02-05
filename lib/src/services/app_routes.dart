import 'package:flutter/material.dart';

import '../screens/game/game_screen.dart';
import '../screens/lobby/lobby_screen.dart';
import '../screens/login/login_screen.dart';
import '../screens/splash/splash_screen.dart';

class AppRoutes {
  AppRoutes._();
  static String get initialRoute => '/splash';
  static Map<String, Widget Function(BuildContext)> get routes => {
        '/splash': (_) => const SplashScreen(),
        '/login': (_) => const LoginScreen(),
        '/lobby': (_) => const LobbyScreen(),
        '/game': (_) => const GameScreen(),
      };
}
