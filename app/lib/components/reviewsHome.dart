import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import './reviewHomeCard.dart';

import '../models/reviewModel.dart';

class ReviewsHome extends StatelessWidget {
  final List<ReviewHomeCard> reviewHomeCards;

  ReviewsHome({required this.reviewHomeCards});

  @override
  Widget build(BuildContext context) {
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
      items: reviewHomeCards.map((reviewCard) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 5.0),
              child: reviewCard,
            );
          },
        );
      }).toList(),
    );
  }
}

class ReviewsHomeWrapper extends StatelessWidget {
  Future<List<ReviewHomeCard>> fetchReviews() async {
    try {
      final reviewsUrl = Uri.parse('${AppConfig.apiBaseUrl}/Avis');
      final reviewsResponse = await http.get(reviewsUrl);

      if (reviewsResponse.statusCode == 200) {
        final List<dynamic> reviewsJsonList = json.decode(reviewsResponse.body);

        reviewsJsonList.shuffle();
        final List<dynamic> randomReviews = reviewsJsonList.take(3).toList();

        List<ReviewHomeCard> reviewHomeCards = await Future.wait(randomReviews.map((jsonReview) async {
          final restaurantUrl = Uri.parse('${AppConfig.apiBaseUrl}/Restaurants/${jsonReview['idRestaurant']}');
          final userUrl = Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs/${jsonReview['idUser']}');

          final restaurantResponse = await http.get(restaurantUrl);
          final userResponse = await http.get(userUrl);

          if (restaurantResponse.statusCode == 200 && userResponse.statusCode == 200) {
            final Map<String, dynamic> restaurantJson = json.decode(restaurantResponse.body);
            final Map<String, dynamic> userJson = json.decode(userResponse.body);

            List<String>? images = jsonReview['image'] != null ? List<String>.from(jsonReview['image']) : null;

            return ReviewHomeCard(
              review: Review(
                id: jsonReview['id'],
                idRestaurant: jsonReview['idRestaurant'],
                idUser: jsonReview['idUser'],
                note: jsonReview['note'],
                commantaire: jsonReview['commantaire'],
                images: images,
              ),
              restaurantName: restaurantJson["nom"],
              userName: userJson["nom"] + " " + userJson["prenom"],
            );
          } else {
            throw Exception('Failed to load data from the API');
          }
        }).toList());

        return reviewHomeCards;
      } else {
        throw Exception('Failed to load data from the API');
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
          List<ReviewHomeCard> reviews = snapshot.data as List<ReviewHomeCard>;
          return ReviewsHome(reviewHomeCards: reviews);
        }
      },
    );
  }
}