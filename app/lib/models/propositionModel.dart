class Proposition {
  final int id;
  final DateTime date;
  final DateTime endingVote;
  final int restaurantId;
  final int utilisateurId;
  late final List<int>? usersOk;

  Proposition({
    required this.id,
    required this.date,
    required this.endingVote,
    required this.restaurantId,
    required this.utilisateurId,
    this.usersOk,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String().split('T')[0],
      'endingVote': endingVote.toIso8601String().split('T')[0],
      'restaurantId': restaurantId,
      'utilisateurId': utilisateurId,
      'usersOk': usersOk,
    };
  }

  static Proposition fromJson(Map<String, dynamic> json) {
    return Proposition(
      id: json['id'],
      date: DateTime.parse(json['date']),
      endingVote: DateTime.parse(json['endingVote']),
      restaurantId: json['restaurantId'],
      utilisateurId: json['utilisateurId'],
      usersOk: List<int>.from(json['usersOk']),
    );
  }
}
