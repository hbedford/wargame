import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wargame/src/services/observable_server.dart';
import 'package:wargame/src/views/game/widgets/user_info_widget.dart';

import 'widgets/territory_item_widget.dart';

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  getList(BuildContext context, bool isHeight, double position) =>
      (isHeight
          ? MediaQuery.of(context).size.height
          : MediaQuery.of(context).size.width) -
      (position * 3);
  @override
  Widget build(BuildContext context) {
    return Consumer<ObservableServer>(
      builder: (_, provider, child) {
        return Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  Column(
                    children: [
                      Text(
                        'Usuario selecionado',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "${provider.userSelected?.name}",
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        'soldados a ser adicionado',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        '${provider.amountSoldierOfUserSelected}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: provider.server!.users
                        .map<Widget>((user) => UserInfoWidget(
                              user: user,
                              amountSoldiers: provider.amountSoldiersPerUser[
                                  provider.server!.users.indexOf(user)],
                              amountTerritories:
                                  provider.amountTerritoriesPerUser[
                                      provider.server!.users.indexOf(user)],
                            ))
                        .toList(),
                  ),
                  Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width *
                            (provider.timeProgress / 100),
                        height: 10,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Stack(
              children: provider.territories
                  .map<Widget>((territory) => TerritoryItemWidget(
                      onTap: () =>
                          provider.attack(territory, territory.userId!),
                      territory: territory,
                      user: provider.server!.users.firstWhere(
                          (element) => element.id == territory.userId)))
                  .toList(),
            ),
          ],
        );
      },
    );
  }
}
