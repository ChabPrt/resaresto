import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:app/config/app_config.dart';
import '../models/wishModel.dart';
import 'package:http/http.dart' as http;

class WishCard extends StatelessWidget {
  final Wish wish;

  WishCard({required this.wish});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: AppConfig.primaryColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<String>(
              future: loadUserName(wish.utilisateurId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading user data: ${snapshot.error}');
                } else {
                  return Text('Créé par : ${snapshot.data}');
                }
              },
            ),
            FutureBuilder<String>(
              future: loadRestaurantName(wish.restaurantId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading restaurant data: ${snapshot.error}');
                } else {
                  return Text('Lieu : ${snapshot.data}');
                }
              },
            ),
            FutureBuilder<List<String>>(
              future: loadUserNames(wish.usersOk),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading user data: ${snapshot.error}');
                } else {
                  List<String> userNames = snapshot.data ?? [];
                  return Text(
                    'Personnes intéressées : ${userNames.isEmpty ? "Personne..." : userNames.join(', ')}',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> loadUserNames(List<int>? usersOk) async {
    List<String> userNames = [];

    if (usersOk != null) {
      for (int userId in usersOk) {
        userNames.add(await loadUserName(userId));
      }
    }

    return userNames;
  }

  Future<String> loadUserName(int userId) async {
    final userApiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs/$userId');
    final userResponse = await http.get(userApiUrl);

    if (userResponse.statusCode == 200) {
      Map<String, dynamic> userJson = json.decode(userResponse.body);
      return '${userJson['nom']} ${userJson['prenom']}';
    } else {
      throw Exception('Failed to load user data from the API');
    }
  }

  Future<String> loadRestaurantName(int restaurantId) async {
    final restaurantApiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Restaurants/$restaurantId');
    final restaurantResponse = await http.get(restaurantApiUrl);

    if (restaurantResponse.statusCode == 200) {
      Map<String, dynamic> restaurantJson = json.decode(restaurantResponse.body);
      return restaurantJson['nom'];
    } else {
      throw Exception('Failed to load restaurant data from the API');
    }
  }
}
