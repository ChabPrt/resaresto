import 'package:app/components/wishForm.dart';
import 'package:app/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/restaurantModel.dart';
import '../components/reviewsRestaurant.dart';
import '../models/reviewModel.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final String date;
  late Review rewiew;

  RestaurantCard({required this.restaurant, required this.date});

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
                padding: const EdgeInsets.all(15.0),
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      "Faire une proposition de réservation ",
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    FloatingActionButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return WishForm(restaurant: restaurant, date: date);
                          },
                        );
                      },
                      child: Icon(Icons.add),
                      backgroundColor: AppConfig.primaryColor,
                    ),
                  ],
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Carousel extends StatelessWidget {
  final List<String> images;

  const Carousel({required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (images.length == 1)
            Image.network(
              images[0],
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          if (images.length > 1)
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
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

