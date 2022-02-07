import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resultlr/resultlr.dart';
import 'package:wargame/main.dart';
import 'package:wargame/src/services/app_navigator.dart';
import 'package:wargame/src/services/app_snackbars.dart';
import 'package:wargame/src/services/observable_server.dart';
import 'package:wargame/src/views/lobby/widgets/user_listtile_widget.dart';

import '../../models/failure/failure.dart';
import 'lobby_viewmodel.dart';

class CreationServerView extends StatelessWidget {
  const CreationServerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LobbyViewModel>(
      builder: (_, provider, __) => Consumer<ObservableServer>(
        builder: (_, providerServer, __) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: providerServer.getOutServer,
                  child: const Icon(Icons.arrow_back_ios),
                ),
                Text(appStrings.string('titleLobby')),
              ],
            ),
            Flexible(
              child: Row(
                children: [
                  const SizedBox(width: 25),
                  Flexible(
                    child: ListView.builder(
                      itemCount: providerServer.server!.amountUsers,
                      itemBuilder: (context, int index) => UserListTileWidget(
                        index: index,
                        user: providerServer.server!.users.length > index
                            ? providerServer.server!.users[index]
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(provider.isHost ? 1 : 0.2),
                      borderRadius: BorderRadius.circular(8)),
                  child: InkWell(
                    child: Text(appStrings.string(
                        provider.isHost ? 'lobbyStart' : 'lobbyWaiting')),
                    onTap: () async {
                      ResultLR<Failure, bool> result =
                          await provider.startGame();
                      if (result.isRight()) {
                        provider.start();
                        provider.updateServer(provider.server);
                        AppNavigator.pushNameAndRemoveAll('/game');
                        return;
                      }
                      AppSnackBars.error(
                          ((result as Left).value as Failure).message);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
