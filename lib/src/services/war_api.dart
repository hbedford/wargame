import 'package:hasura_connect/hasura_connect.dart';
import 'package:resultlr/resultlr.dart';
import 'package:wargame/main.dart';
import 'package:wargame/src/services/graphql/server_graphql.dart';

import '../models/failure/failure.dart';
import '../models/server/server.dart';
import '../models/user/user.dart';
import 'graphql/login_graphql.dart';

class WarAPI {
  static String get _apiUrl => 'https://game-war.herokuapp.com/v1/graphql';

  final HasuraConnect _hasuraConnect = HasuraConnect(_apiUrl);
  Future<ResultLR<Failure, User>> login(String email) async {
    Map<String, dynamic> result =
        await _hasuraConnect.query(GraphQLLogin.login(email: email));
    if (result['data'] != null) {
      List<User> users = result['data']['user']
          .map<User>((item) => User.fromJson(item))
          .toList();
      if (users.isNotEmpty) {
        return Right(users.first);
      } else {
        return Left(Failure(
            code: 501,
            message: appStrings.string("emailNotRegisteredMessage")));
      }
    }
    return Left(Failure(code: 500, message: 'Algum erro'));
  }

  Future<ResultLR<Failure, User>> registerAccount(
      {required String email, required String name}) async {
    Map<String, dynamic> result = await _hasuraConnect
        .mutation(GraphQLLogin.register(email: email, name: name));
    if (result['data'] != null) {
      User user = result['data']['insert_user']['returning']
          .map<User>(User.fromJson)
          .toList()
          .first;
      return Right(user);
    }
    return Left(Failure(code: 500, message: 'Algum erro'));
  }

  //Servers
  Future<Snapshot> listenServers() async {
    return await _hasuraConnect.subscription(ServerGraphQL.listenServers);
  }

  Future<ResultLR<Failure, Server>> openServer(User user) async {
    Map<String, dynamic> result =
        await _hasuraConnect.mutation(ServerGraphQL.openServer(user.id));
    if (result['data'] != null) {
      return Right(
          Server.fromJson(result['data']['insert_server']['returning'].first));
    } else {
      return Left(Failure(code: 100, message: ''));
    }
  }

  Future<ResultLR<Failure, bool>> startGame(int serverId) async {
    Map<String, dynamic> result =
        await _hasuraConnect.mutation(ServerGraphQL.startGame(serverId));
    if (result['data'] != null) {
      return Right((result['data']['update_server']['affected_rows'] > 0));
    }
    return Left(Failure(code: 0, message: ''));
  }

  Future<ResultLR<Failure, Server>> connectToServer(
      int serverId, int userId) async {
    Map<String, dynamic> result = await _hasuraConnect
        .mutation(ServerGraphQL.connectToServer(serverId, userId));
    if (result['data'] != null) {
      List<Map<String, dynamic>> list =
          result['data']['insert_server_users']['returning'];
      return Right(
          list.first['server'].map<Server>((item) => Server.fromJson(item)));
    }
    return Left(Failure(code: 0, message: ''));
  }

  Future<dynamic> addTerritories(List<Map<String, dynamic>> list) async {
    return await _hasuraConnect.mutation(ServerGraphQL.addTerritories(list),
        variables: {'objects': list}).catchError((e) => print(e));
  }
}
