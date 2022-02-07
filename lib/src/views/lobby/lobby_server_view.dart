import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resultlr/resultlr.dart';
import 'package:wargame/main.dart';
import 'package:wargame/src/services/observable_server.dart';

import '../../models/failure/failure.dart';
import '../../models/server/server.dart';
import 'lobby_viewmodel.dart';
import 'widgets/server_listtile_widget.dart';

class LobbyServersView extends StatelessWidget {
  const LobbyServersView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LobbyViewModel>(
      builder: (_, provider, __) =>
          Consumer<ObservableServer>(builder: (_, providerServers, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(appStrings.string('titleLobbyServers')),
                TextButton(
                  onPressed: provider.deslogar,
                  child: Text(appStrings.string('logoutLobby')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const SizedBox(width: 25),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : providerServers.servers.isEmpty
                          ? Center(
                              child: Text(appStrings.string('lobbyListEmpty')),
                            )
                          : ListView.builder(
                              itemCount: providerServers.servers.length,
                              itemBuilder: (context, int index) => InkWell(
                                onTap: () => provider.connectToServer(
                                    providerServers.servers[index]),
                                child: ServerListTileWidget(
                                  index: index,
                                  server: providerServers.servers[index],
                                  amountUsers: providerServers
                                      .servers[index].amountUsers,
                                ),
                              ),
                            ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton.filled(
                  child: Text(appStrings.string('lobbyCreateServer')),
                  onPressed: () async {
                    ResultLR<Failure, Server> result =
                        await provider.openServer();
                    if (result.isRight()) {
                      print((result as Right).value.id);
                      providerServers.changeServer((result as Right).value);
                    }
                  },
                ),
              ],
            ),
          ],
        );
      }),
    );
  }
}
