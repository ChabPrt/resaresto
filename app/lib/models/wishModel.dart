import 'package:app/models/restaurantModel.dart';
import 'package:app/models/userModel.dart';

class Wish {
  final int? id;
  final DateTime date;
  final DateTime endingVote;
  final Restaurant restaurant;
  final User utilisateur;
  final List<int>? usersOk;

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
      'date': date.toIso8601String(),
      'endingVote': endingVote.toIso8601String(),
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
