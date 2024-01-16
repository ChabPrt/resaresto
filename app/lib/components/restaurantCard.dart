import 'package:flutter/material.dart';
import '../models/restaurantModel.dart';
import '../components/reviewsRestaurant.dart';
import '../models/reviewModel.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  late Review rewiew;

  RestaurantCard({required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                child: Carousel(images: restaurant.image ?? []),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nom
                      Text(
                        restaurant.nom,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      // Adresse
                      Text(
                        restaurant.adresse,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      // Note
                      Row(
                        children: List.generate(
                          5,
                              (index) {
                            if (index < restaurant.note.round()) {
                              return Icon(
                                Icons.star,
                                color: Colors.orange,
                              );
                            } else {
                              return Icon(
                                Icons.star,
                                color: Colors.grey,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Les avis : ",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ReviewsRestaurantWrapper(idRestaurant: restaurant.id ?? 0),
            ],
          ),
        ],
      ),
    );
  }
}

// Placeholder pour le widget de carrousel (remplacez-le par votre propre implementation de carrousel)
class Carousel extends StatelessWidget {
  final List<String> images;

  const Carousel({required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (images.isNotEmpty)
          // Afficher le carrousel d'images si des images sont disponibles
            Placeholder(), // Remplacez ceci par votre implémentation réelle du carrousel
          if (images.isEmpty)
            Column(
              children: [
                Icon(Icons.image, size: 50, color: Colors.grey),
                Text('Aucune image du restaurant'),
              ],
            ),
        ],
      ),
    );
  }
}
