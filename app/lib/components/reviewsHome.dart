import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import './reviewCard.dart';

import '../models/reviewModel.dart';
import '../models/restaurantModel.dart';
import '../models/userModel.dart';

class ReviewsHome extends StatelessWidget {
  final List<ReviewCard> reviewCards;

  ReviewsHome({required this.reviewCards});

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
      items: reviewCards.map((reviewCard) {
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
  Future<List<ReviewCard>> fetchReviews() async {
    // Load JSON files for restaurants, reviews, and users

      String jsonString = await rootBundle.loadString('../data/reviews.json');
      List<dynamic> jsonList = json.decode(jsonString)['reviews'];

      List<dynamic> randomReviews = [...jsonList];
      randomReviews.shuffle();
      randomReviews = randomReviews.take(3).toList();

      String restaurantsJsonString = await rootBundle.loadString('../data/restaurants.json');
      List<dynamic> restaurantsJsonList = json.decode(restaurantsJsonString)['restaurants'];

      String usersJsonString = await rootBundle.loadString('../data/users.json');
      List<dynamic> usersJsonList = json.decode(usersJsonString)['Users'];

      List<ReviewCard> reviewCards = randomReviews.map((jsonReview) {
        // Find the corresponding restaurant using the restaurant ID
        Map<String, dynamic> restaurantJson = restaurantsJsonList
            .firstWhere((restaurant) => restaurant['id'] == jsonReview['restaurant_id']);
        Restaurant restaurant = Restaurant.fromJson(restaurantJson);

        // Find the corresponding user using the user ID
        Map<String, dynamic> userJson = usersJsonList
            .firstWhere((user) => user['id'] == jsonReview['user_id']);
        User user = User.fromJson(userJson);

        return ReviewCard(
          review: Review(
            id: jsonReview['id'],
            restaurantId: jsonReview['restaurant_id'],
            userId: jsonReview['user_id'],
            rating: jsonReview['rating'].toDouble(),
            comment: jsonReview['comment'],
            images: jsonReview['images'] != null ? List<String>.from(jsonReview['images']) : null,
          ),
          restaurantName: restaurant.name,
          userName: user.nom + " " + user.prenom,
        );
      }).toList();

      return reviewCards;

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
          List<ReviewCard> reviews = snapshot.data as List<ReviewCard>;
          return ReviewsHome(reviewCards: reviews);
        }
      },
    );
  }
}
