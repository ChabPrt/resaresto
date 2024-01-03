class User {
  final int id;
  final String role;
  final String name;
  final String mail;
  final String pass;
  final String? image;

  User({
    required this.id,
    required this.role,
    required this.name,
    required this.mail,
    required this.pass,
    this.image,
  });

  static User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      role: json['role'],
      name: json['name'],
      mail: json['mail'],
      pass: json['pass'],
      image: json['image'],
    );
  }
}
