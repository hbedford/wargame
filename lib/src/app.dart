import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wargame/src/cores/app_providers.dart';
import 'package:wargame/src/cores/app_routes.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        initialRoute: AppRoutes.initialRoute,
        routes: AppRoutes.routes,
      ),
    );
  }
}
