class Restaurant {
  final int? id;
  final String nom;
  final String typeCuisine;
  final double note;
  final List<String>? image;
  final String address;

  Restaurant({
    this.id,
    required this.nom,
    required this.typeCuisine,
    required this.note,
    this.image,
    required this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'typeCuisine': typeCuisine,
      'note': note,
      'image': image,
      'address': address,
    };
  }

  static Restaurant fromJson(Map<String, dynamic> json) {
    return Restaurant (
      id: json['id'],
      nom: json['nom'],
      typeCuisine: json['typeCuisine'],
      note: json['note'].toDouble(),
      image: List<String>.from(json['image']),
      address: json['address'],
    );
  }
}

