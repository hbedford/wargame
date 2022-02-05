class User {
  final int id;
  User({
    required this.id,
  });
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
      );
  Map<String, dynamic> get toJson => {
        'id': id,
      };
}
