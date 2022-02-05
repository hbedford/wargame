import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wargame/src/services/observable_server.dart';

import '../services/war_api.dart';
import 'selected_theme.dart';

class AppProviders {
  AppProviders._();
  static List<SingleChildWidget> get providers => [
        Provider.value(value: WarAPI()),
        Provider.value(value: GetStorage()),
        ChangeNotifierProvider(create: (_) => ObservableServer()),
        ChangeNotifierProvider(create: (_) => SelectedTheme()),
      ];
}
