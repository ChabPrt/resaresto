class Group {
  final int? id;
  final String libelle;
  final String? code;
  final List<String>? propositions;
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
      'propositions': propositions,
      'utilisateurs': utilisateurs,
    };
  }

  static Group fromJson(Map<String, dynamic> json) {
    return Group (
      id: json['id'],
      libelle: json['libelle'],
      code: json['code'],
      propositions: List<String>.from(json['propositions']),
      utilisateurs: List<String>.from(json['utilisateurs']),
    );
  }
}

