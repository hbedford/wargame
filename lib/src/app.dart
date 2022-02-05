import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wargame/main.dart';
import 'package:wargame/src/services/selected_theme.dart';

import 'services/app_providers.dart';
import 'services/app_routes.dart';

GlobalKey<NavigatorState> navigationApp = GlobalKey<NavigatorState>();

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  load() async => await appStrings.load();

  @override
  Widget build(BuildContext context) {
    load();
    return MultiProvider(
      providers: AppProviders.providers,
      child: Selector<SelectedTheme, ThemeData>(
        selector: (_, selected) => selected.theme,
        builder: (_, theme, __) => MaterialApp(
          theme: theme,
          navigatorKey: navigationApp,
          initialRoute: AppRoutes.initialRoute,
          routes: AppRoutes.routes,
        ),
      ),
    );
  }
}
