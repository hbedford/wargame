import 'package:flutter/rendering.dart';

class Territory {
  final int id;
  final String name;
  int? userId;
  int amountSoldiers;
  Offset offset;
  List<int> neighbors;
  int continentId;
  Territory({
    required this.id,
    required this.name,
    this.userId,
    this.amountSoldiers = 1,
    this.offset = Offset.zero,
    required this.neighbors,
    required this.continentId,
  });
  factory Territory.fromJson(Map<String, dynamic> json) => Territory(
        id: json['id'],
        name: json['name'],
        amountSoldiers: json['amountsoldiers'],
        offset: Offset(
          double.parse(json['offset'].split(',').first),
          double.parse(json['offset'].split(',').last),
        ),
        neighbors: json['neighbors'],
        continentId: json['continent_id'],
      );
  Map<String, dynamic> get toJson => {
        "id": id,
        'name': name,
        'amountsoldiers': amountSoldiers,
        'continent_id': continentId,
        'offset': "${offset.dx},${offset.dy}",
        'neighbors': neighbors.toString(),
      };
}
