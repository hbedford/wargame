import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:resultlr/resultlr.dart';

import '../../models/continents/continent.dart';
import '../../models/failure/failure.dart';
import '../../models/server/server.dart';
import '../../models/territory/territory.dart';
import '../../models/user/user.dart';
import '../../services/app_navigator.dart';
import '../../services/data_info.dart';
import '../../services/war_api.dart';

class LobbyViewModel with ChangeNotifier {
  late GetStorage _getStorage;
  late WarAPI _api;

  final List<Continent> _continents = [
    DataInfo.americaDoNorte,
    DataInfo.americaDoSul,
    DataInfo.europa,
    DataInfo.africa,
    DataInfo.asia,
    DataInfo.oceania
  ];
  List<Continent> get continents => _continents;

  List<Territory> get territories {
    List<Territory> list = [];
    for (Continent continent in _continents) {
      list.addAll(continent.territories);
    }
    return list;
  }

  Server? _server;
  Server? get server => _server;

  User? _user;
  User? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _disposed = false;
  bool get isHost => _server != null && _server!.hostUser.id == _user!.id;

  List<Territory> get territoriesWithoutUser {
    List<Territory> list = [];
    for (Continent continent in _continents) {
      list.addAll(
          continent.territories.where((territory) => territory.userId == null));
    }
    return list;
  }

  loadUser() {
    User result = User.fromJson(jsonDecode(_getStorage.read('user')));
    changeUser(result);
  }

  update(
      {required WarAPI api, required GetStorage getStorage, Server? server}) {
    _api = api;
    _getStorage = getStorage;
    changeServer(server);
    loadUser();
    print('${_user?.id} ${_server?.hostUser.id}');
    print('changed server selected on lobby');
  }

  changeIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  changeUser(User? value) {
    _user = value;
    notifyListeners();
  }

  deslogar() {
    _getStorage.write('user', null);
    AppNavigator.pushNameAndRemoveAll('/login');
  }

  openServer() async {
    ResultLR<Failure, Server> result = await _api.openServer(_user!);
    return result;
  }

  changeServer(Server? value) {
    _server = value;
    notifyListeners();
  }

  Future<ResultLR<Failure, bool>> startGame() async {
    changeIsLoading(true);
    ResultLR<Failure, bool> result = await _api.startGame(_server!.id);
    if (result.isLeft()) changeIsLoading(false);
    return result;
  }

  connectToServer(Server value) async {
    ResultLR<Failure, Server> result =
        await _api.connectToServer(value.id, _user!.id);
    if (result.isRight()) {
      changeServer((result as Right).value);
    }
  }

  start() {
    int indexUser = 0;
    while (territoriesWithoutUser.length > 0) {
      Territory territory = (territoriesWithoutUser..shuffle()).first;
      addUserOnTerritory(territory, indexUser);
      if (indexUser + 1 == server!.users.length)
        indexUser = 0;
      else
        indexUser++;
    }
    addTerritories();
  }

  addTerritories() async {
    var result = await _api.addTerritories(
        territories.map<Map<String, dynamic>>((e) => e.toJson).toList());
  }

  addUserOnTerritory(Territory territory, int indexUser) {
    _continents[getIndexOfContinent(territory.id)]
        .territories
        .firstWhere((item) => item.id == territory.id)
        .userId = server!.users[indexUser].id;
    _continents[getIndexOfContinent(territory.id)]
        .territories
        .firstWhere((item) => item.id == territory.id)
        .amountSoldiers = 100;
    notifyListeners();
  }

  getIndexOfContinent(int id) {
    for (Continent continent in _continents) {
      if (continent.territories.any((element) => element.id == id)) {
        return _continents.indexOf(continent);
      }
    }
  }

  updateServer(Server? value) {}
  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
