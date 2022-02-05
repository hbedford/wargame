class User {
  final int id;
  String email;
  User({
    required this.id,
    required this.email,
  });
  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        email: json['email'],
      );
  Map<String, dynamic> get toJson => {
        'id': id,
        'email': email,
      };
}
