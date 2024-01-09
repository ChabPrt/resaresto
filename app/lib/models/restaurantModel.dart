// restaurant.dart

class Restaurant {
  final int id;
  final String name;
  final String cuisine;
  final double rating;
  final Address address;
  final String image;

  Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.address,
    required this.image,
  });

  static Restaurant fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      cuisine: json['cuisine'],
      rating: json['rating'].toDouble(),
      address: Address.fromJson(json['address']),
      image: json['image'] ?? "",
    );
  }
}

class Address {
  final String street;
  final String city;
  final String zipcode;

  Address({
    required this.street,
    required this.city,
    required this.zipcode,
  });

  static Address fromJson(Map<String, dynamic> json) {
    return Address(
      street: json['street'],
      city: json['city'],
      zipcode: json['zipcode'],
    );
  }
}
