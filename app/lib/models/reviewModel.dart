// review.dart
class Review {
  final int id;
  final int restaurantId;
  final int userId;
  final double rating;
  final String comment;
  final List<String>? images;

  Review({
    required this.id,
    required this.restaurantId,
    required this.userId,
    required this.rating,
    required this.comment,
    this.images,
  });
}
