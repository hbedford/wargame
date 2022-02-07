import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:wargame/src/services/observable_server.dart';
import 'package:wargame/src/services/war_api.dart';

import '../../models/server/server.dart';
import 'creation_server_view.dart';
import 'lobby_server_view.dart';
import 'lobby_viewmodel.dart';

class LobbyView extends StatelessWidget {
  const LobbyView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider2<WarAPI, GetStorage, ObservableServer>(
      create: (_) => ObservableServer(),
      update: (_, api, getStorage, viewModel) =>
          viewModel!..update(api: api, getStorage: getStorage),
      child: ChangeNotifierProxyProvider3<WarAPI, GetStorage, ObservableServer,
          LobbyViewModel>(
        create: (_) => LobbyViewModel(),
        update: (_, api, getStorage, server, viewModel) => viewModel!
          ..update(api: api, getStorage: getStorage, server: server.server),
        child: Selector<ObservableServer, Server?>(
          selector: (_, provider) => provider.server,
          builder: (_, server, child) => server != null
              ? const CreationServerView()
              : const LobbyServersView(),
        ),
      ),
    );
  }
}
