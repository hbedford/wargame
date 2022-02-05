import 'package:hasura_connect/hasura_connect.dart';
import 'package:resultlr/resultlr.dart';
import 'package:wargame/main.dart';

import '../models/failure/failure.dart';
import '../models/user/user.dart';
import 'graphql/graphql_login.dart';

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
}
