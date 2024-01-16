import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/reviewModel.dart';
import '../components/reviewRestaurantCard.dart';

class ReviewsRestaurant extends StatelessWidget {
  final List<ReviewRestaurantCard> reviewRestaurantCards;

  ReviewsRestaurant({required this.reviewRestaurantCards});

  @override
  Widget build(BuildContext context) {
    if (reviewRestaurantCards.isEmpty) {
      return Center(
        child: Text(
          "Aucun avis sur ce restaurant pour le moment...",
          style: TextStyle(fontSize: 16.0),
        ),
      );
    }

    if (reviewRestaurantCards.length == 1) {
      return reviewRestaurantCards.first;
    }

    return CarouselSlider(
      options: CarouselOptions(
        height: 350.0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        pauseAutoPlayOnTouch: true,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      items: reviewRestaurantCards.map((reviewRestaurantCard) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: reviewRestaurantCard,
            );
          },
        );
      }).toList(),
    );
  }
}

class ReviewsRestaurantWrapper extends StatelessWidget {
  final int idRestaurant;

  ReviewsRestaurantWrapper({required this.idRestaurant});

  Future<List<ReviewRestaurantCard>> fetchReviews() async {
    try {
      final restaurantUrl =
      Uri.parse('${AppConfig.apiBaseUrl}/Restaurants/RecupererAvis/$idRestaurant');
      final reviewsResponse = await http.get(restaurantUrl);

      if (reviewsResponse.statusCode == 200) {
        final List<dynamic> jsonReviews = json.decode(reviewsResponse.body);
        List<ReviewRestaurantCard> reviewRestaurantCards =
        await Future.wait(jsonReviews.map((jsonReview) async {
          final userUrl = Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs/${jsonReview['idUser']}');
          final userResponse = await http.get(userUrl);

          if (userResponse.statusCode == 200) {
            final Map<String, dynamic> userJson = json.decode(userResponse.body);

            return ReviewRestaurantCard(
              review: Review.fromJson(jsonReview),
              userName: '${userJson["nom"]} ${userJson["prenom"]}',
            );
          } else {
            throw Exception('Failed to load user data from the API');
          }
        }).toList());

        return reviewRestaurantCards;
      } else {
        throw Exception('Failed to load reviews from the API');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchReviews(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return const Text('Error loading data');
        } else {
          List<ReviewRestaurantCard> reviews = snapshot.data as List<ReviewRestaurantCard>;
          return ReviewsRestaurant(reviewRestaurantCards: reviews);
        }
      },
    );
  }
}
