import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/restaurantModel.dart';
import '../components/restaurantCard.dart';
import 'package:app/views/homeView.dart';

class RestaurantList extends StatelessWidget {
  final String address;
  final String date;

  RestaurantList({required this.address, required this.date});

  Future<List<Restaurant>> fetchRestaurantByAddress(String address) async {
    try {
      final response =
      await http.get(Uri.parse('${AppConfig.apiBaseUrl}/Restaurants/Recuperer/$address'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Restaurant> restaurants = data.map((json) => Restaurant.fromJson(json)).toList();
        return restaurants;
      } else {
        throw Exception('Failed to load restaurants. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load restaurants: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchRestaurantByAddress(address),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading restaurant data: ${snapshot.error}'));
        } else {
          List<Restaurant> restaurants = snapshot.data as List<Restaurant>;

          if (restaurants.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Oups ! Aucun restaurant n'a été trouvé avec cette adresse. Merci de contacter votre administrateur.",
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomeView()), // Navigate to HomeView
                      );
                    },
                    child: Text(
                      "Revenir en arrière",
                      style: TextStyle(fontSize: 16.0, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            );
          }

          return Container(
            height: 500.0,
            child: ListView.builder(
              itemCount: restaurants.length,
              itemBuilder: (context, index) {
                Restaurant restaurant = restaurants[index];
                return RestaurantCard(restaurant: restaurant, date: date);
              },
            ),
          );
        }
      },
    );
  }
}
