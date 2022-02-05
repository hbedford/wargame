import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wargame/src/services/observable_server.dart';

class AppProviders {
  AppProviders._();
  static List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(
          create: (_) => ObservableServer(),
        )
      ];
}
