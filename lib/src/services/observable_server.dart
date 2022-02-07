import 'package:flutter/cupertino.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hasura_connect/hasura_connect.dart';
import 'package:wargame/src/services/app_snackbars.dart';
import 'package:wargame/src/services/war_api.dart';

import '../models/continents/continent.dart';
import '../models/server/server.dart';
import 'package:collection/collection.dart';

import '../models/territory/territory.dart';
import '../models/user/user.dart';
import 'data_info.dart';
import 'dart:math';

class ObservableServer with ChangeNotifier {
  late WarAPI _api;
  late GetStorage _getStorage;

  List<Server> _servers = [];
  List<Server> get servers => _servers;

  Server? _server;
  Server? get server => _server;

  User? _user;
  User? get user => _user;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  int get timeProgress => 10;

  User? get userSelected =>
      _server?.users.firstWhere((user) => user.id == _server?.userSelectedId);

  final List<Continent> _continents = [
    DataInfo.americaDoNorte,
    DataInfo.americaDoSul,
    DataInfo.europa,
    DataInfo.africa,
    DataInfo.asia,
    DataInfo.oceania
  ];
  List<Continent> get continents => _continents;

  int get territoriesLength {
    int value = 0;
    _continents.forEach((element) {
      value += element.length;
    });
    return value;
  }

  List<int> get amountSoldiersPerUser {
    List<int> list = List.filled(_server?.users.length ?? 0, 0);
    for (int i = 0; i < _server!.users.length; i++) {
      int amount = 0;
      for (Territory territory in territories) {
        if (territory.userId == _server!.users[i].id)
          amount += territory.amountSoldiers;
      }

      list[i] = amount;
    }
    return list;
  }

  List<int> get amountTerritoriesPerUser {
    List<int> list = List.filled(_server?.users.length ?? 0, 0);
    for (int i = 0; i < _server!.users.length; i++) {
      int amount = 0;
      for (Territory territory in territories) {
        if (territory.userId == _server!.users[i].id) amount++;
      }

      list[i] = amount;
    }
    return list;
  }

  List<Territory> get territoriesWithoutUser {
    List<Territory> list = [];
    _continents.forEach((continent) {
      list.addAll(
          continent.territories.where((territory) => territory.userId == null));
    });
    return list;
  }

  List<Territory> get territories {
    List<Territory> list = [];
    _continents.forEach((continent) => list.addAll(continent.territories));
    return list;
  }

  Territory? _territorySelected;
  Territory? get territory => _territorySelected;

  int? get amountSoldierOfUserSelected {
    if (_server == null) return null;
    int index = _server!.users
        .indexWhere((element) => element.id == _server?.userSelectedId);
    return index != -1 ? amountSoldiersPerUser[index] : null;
  }

  update({required WarAPI api, required GetStorage getStorage}) {
    _api = api;
    _getStorage = getStorage;
    loadServers();
  }

  Future<Snapshot> loadServers() async {
    Snapshot snapshot = await _api.listenServers();
    snapshot.listen((result) {
      changeServers(result['data']['server']
          .map<Server>((item) => Server.fromJson(item))
          .toList());
      print('get update of servers');
      if (_server != null) {
        print(_server!.id);
        changeServer(_servers.firstWhereOrNull((s) => s.id == _server!.id));
      }
      changeIsLoading(false);
    });
    return snapshot;
  }

  changeIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  changeServers(List<Server> value) {
    _servers = value;
    notifyListeners();
  }

  changeServer(Server? value) {
    _server = value;
    notifyListeners();
  }

  bool attack(Territory territory, int userId) {
    if (_server!.userSelectedId != _user!.id) {
      AppSnackBars.error('Não esta na sua vez');
      return false;
    }

    if (_territorySelected == null &&
        territory.userId != _server!.userSelectedId) return false;

    //se o territorio é do usuario  e é o usuario atual a atacar
    if ((_territorySelected == null &&
            territory.userId == _server!.userSelectedId) ||
        _territorySelected!.userId == userId) {
      changeSelectTerritory(territory);
      return false;
    }
    //se o territorio selecionado que quer usar para atacar tiver apenas 1 soldado
    if (_territorySelected!.amountSoldiers == 1) {
      changeSelectTerritory(null);
      return false;
    }

    //verifica se é um vizinho atacavel
    if (!_territorySelected!.neighbors.contains(territory.id)) {
      AppSnackBars.error('Este territorio não é um vizinho atacavel');
      return false;
    }

    return realizeAttack(territory);
  }

  changeSelectTerritory(Territory? value) {
    _territorySelected = value;
    notifyListeners();
  }

  bool realizeAttack(Territory territory) {
    //verifica quantos podem atacar, ate no maximo 3, mas mantendo 1 como dono do territorio
    int amountAtack = _territorySelected!.amountSoldiers > 3
        ? 3
        : _territorySelected!.amountSoldiers - 1;

    //verifica quantos podem defender, ate no maximo 3
    int amountDefense =
        territory.amountSoldiers > 2 ? 3 : territory.amountSoldiers;

    //randomiza a lista de valores sorteados e em ordem decrescente  em relaçao ao numero de soldados de cima
    List<int> attackSorted = getRandomValues(amountAtack);
    //randomiza a lista de valores sorteados e em ordem decrescente em relaçao ao numero de soldados de cima
    List<int> defenseSorted = getRandomValues(amountDefense);

    int position = 0;
    int lostDefense = 0;
    int lostAttack = 0;
    for (int value in attackSorted) {
      if (position <= defenseSorted.length - 1) {
        if (value > defenseSorted[position])
          lostDefense++;
        else
          lostAttack++;

        position++;
      }
    }
    print(lostAttack);
    print(lostDefense);
    if (lostDefense >= territory.amountSoldiers) {
      changeTerritoryUser(territory.id);
      changeAmountSoldiers(lostAttack + 1, _territorySelected!);
      return true;
    }

    changeAmountSoldiers(lostDefense, territory);
    changeAmountSoldiers(lostAttack, _territorySelected!);
    return false;
  }

  changeTerritoryUser(int territoryId) {
    Territory t = _continents
        .firstWhere(
            (element) => element.territories.any((t) => t.id == territoryId))
        .territories
        .firstWhere((element) => element.id == territoryId);
    t.userId = _server!.userSelectedId;
    t.amountSoldiers = 1;
    _territorySelected!.amountSoldiers--;
    notifyListeners();
  }

  changeAmountSoldiers(int amount, Territory territory) {
    _continents[getIndexOfContinent(territory.id)]
        .territories
        .firstWhere((element) => territory.id == element.id)
        .amountSoldiers -= amount;
    notifyListeners();
  }

  getIndexOfContinent(int id) {
    for (Continent continent in _continents) {
      if (continent.territories.any((element) => element.id == id))
        return _continents.indexOf(continent);
    }
  }

  //quantidade de numeros aleatorios que queremos ter
  getRandomValues(int amount) {
    //Lista começa vazia
    List<int> list = [];
    //um loop q começa do zero e enquanto i for menor q quantidade de numeros
    for (int i = 0; i < amount; i++) {
      //adiciona um item randomizado a lista, mas esta nextInt, pois o é de 0 a 5, e o 1+ é para garantir q seja de 1 a 6 no final, entao incrementando no 0 a 5 fica 1 a 6
      list.add(1 + Random().nextInt(5));
    }
    //ordena decrescentemente
    list.sort((a, b) => b.compareTo(a));

    //devolve a lista la para onde a funçao getRandomValues foi chamada
    return list;
  }

  getOutServer() {
    changeServer(null);
  }
}
