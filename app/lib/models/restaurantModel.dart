class Restaurant {
  final int? id;
  final String nom;
  final String typeCuisine;
  final double note;
  final String adresse;
  final List<String>? image;
  final List<String>? avis;

  Restaurant({
    this.id,
    required this.nom,
    required this.typeCuisine,
    required this.note,
    required this.adresse,
    this.image,
    this.avis,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'typeCuisine': typeCuisine,
      'note': note,
      'adresse': adresse,
      'image': image,
      'avis': avis,
    };
  }

  static Restaurant fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      nom: json['nom'],
      typeCuisine: json['typeCuisine'],
      note: json['note'],
      adresse: json['adresse'],
      image: json['image'] != null ? List<String>.from(json['image']) : null,
      avis: json['avis'] != null ? List<String>.from(json['avis']) : null,
    );
  }
}
