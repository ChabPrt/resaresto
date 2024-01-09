class User {
  final int? id;
  final String nom;
  final String prenom;
  final String mail;
  final String pass;
  final String? levelAcces;
  final String? image;

  User({
    this.id,
    required this.nom,
    required this.prenom,
    required this.mail,
    required this.pass,
    this.levelAcces,
    this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'nom': nom,
      'prenom': prenom,
      'mail': mail,
      'pass': pass,
      'image': image,
    };
  }

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      mail: json['mail'],
      pass: json['pass'],
      levelAcces: json['levelAcces'],
      image: json['image'],
    );
  }
}
