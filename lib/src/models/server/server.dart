import '../user/user.dart';

class Server {
  final int id;
  final User hostUser;
  final int? userSelectedId;
  final bool isStarted;
  final int amountUsers;
  List<User> users;
  Server({
    required this.id,
    required this.hostUser,
    required this.userSelectedId,
    required this.isStarted,
    required this.amountUsers,
    required this.users,
  });
  factory Server.fromJson(Map json) => Server(
        id: json['id'],
        hostUser: User.fromJson(json['user']),
        userSelectedId: json['selected_user_id'],
        isStarted: json['isstarted'],
        amountUsers: json['server_users_aggregate']['aggregate']['count'],
        users: json['server_users']
            .map<User>((map) => User.fromJson(map['user']))
            .toList(),
      );
}
