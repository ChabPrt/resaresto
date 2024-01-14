import 'package:app/models/wishModel.dart';

class Group {
  final int? id;
  final String libelle;
  final String? code;
  final List<Wish>? propositions;
  final List<String>? utilisateurs;

  Group({
    this.id,
    required this.libelle,
    this.code,
    this.propositions,
    this.utilisateurs,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'libelle': libelle,
      'propositions': propositions?.map((wish) => wish.toJson()).toList(),
      'utilisateurs': utilisateurs,
    };
  }

  static Group fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      libelle: json['libelle'],
      code: json['code'],
      propositions: List<Wish>.from((json['propositions'] ?? []).map((prop) => Wish.fromJson(prop))),
      utilisateurs: List<String>.from(json['utilisateurs']),
    );
  }
}