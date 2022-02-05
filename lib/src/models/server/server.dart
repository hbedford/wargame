class Server {
  final int id;
  Server({
    required this.id,
  });
  factory Server.fromJson(Map<String, dynamic> json) => Server(
        id: json['id'],
      );
  Map<String, dynamic> get toJson => {
        'id': id,
      };
}
