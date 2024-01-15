import 'package:app/models/restaurantModel.dart';
import 'package:app/models/userModel.dart';

class Wish {
  final int? id;
  final DateTime date;
  final DateTime endingVote;
  final Restaurant restaurant;
  final User utilisateur;
  late final List<int>? usersOk;

  Wish({
    this.id,
    required this.date,
    required this.endingVote,
    required this.restaurant,
    required this.utilisateur,
    this.usersOk,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'endingVote': endingVote.toIso8601String().split('T')[0],
      'restaurant': restaurant.toJson(),
      'utilisateur': utilisateur.toJson(),
      'usersOk': usersOk,
    };
  }

  static Wish fromJson(Map<String, dynamic> json) {
    return Wish(
      id: json['id'],
      date: DateTime.parse(json['date']),
      endingVote: DateTime.parse(json['endingVote']),
      restaurant: Restaurant.fromJson(json['restaurant']),
      utilisateur: User.fromJson(json['utilisateur']),
      usersOk: List<int>.from(json['usersOk']),
    );
  }
}
