class Review {
  final int? id;
  final int idRestaurant;
  final int idUser;
  final double note;
  final String commantaire;
  final List<String>? images;

  Review({
    this.id,
    required this.idRestaurant,
    required this.idUser,
    required this.note,
    required this.commantaire,
    this.images,
  });

  Map<String, dynamic> toJson() {
    return {
      'idRestaurant': idRestaurant,
      'idUser': idUser,
      'note': note,
      'commantaire': commantaire,
      'images': images,
    };
  }

  static Review fromJson(Map<String, dynamic> json) {
    return Review (
      id: json['id'],
      idRestaurant: json['idRestaurant'],
      idUser: json['idUser'],
      note: json['note'],
      commantaire: json['commantaire'],
      images: json['images'],
    );
  }
}
