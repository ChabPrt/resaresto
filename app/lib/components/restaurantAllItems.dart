import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/restaurantModel.dart';
import '../components/restaurantCard.dart';

class RestaurantAllItems extends StatefulWidget {
  final void Function(int?) onRestaurantSelected;

  RestaurantAllItems({required this.onRestaurantSelected});

  Future<List<Restaurant>> fetchRestaurants() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/Restaurants'));

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
  _RestaurantAllItemsState createState() => _RestaurantAllItemsState();
}

class _RestaurantAllItemsState extends State<RestaurantAllItems> {
  int? selectedRestaurantId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.fetchRestaurants(),
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
                    "Oups ! Aucun restaurant n'a été trouvé. Veuilliez en créer.",
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
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
                return RestaurantCard(
                  restaurant: restaurant,
                  isSelected: selectedRestaurantId == restaurant.id,
                  onCardSelected: (int restaurantId) {
                    setState(() {
                      if (selectedRestaurantId == restaurantId) {
                        selectedRestaurantId = null;
                      } else {
                        selectedRestaurantId = restaurantId;
                      }
                    });

                    widget.onRestaurantSelected(selectedRestaurantId);
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
