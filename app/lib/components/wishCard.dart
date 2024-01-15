import 'dart:convert';

import 'package:app/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/wishModel.dart';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
             children: [
               Text('Créé par : ${wish.utilisateur.nom} ${wish.utilisateur.prenom}'),
               Text('Lieu : ${wish.restaurant.nom}'),
               FutureBuilder<List<String>>(
                 future: getUserOk(wish.usersOk),
                 builder: (context, snapshot) {
                   if (snapshot.connectionState == ConnectionState.waiting) {
                     return CircularProgressIndicator();
                   } else if (snapshot.hasError) {
                     return Text('Error loading user data: ${snapshot.error}');
                   } else {
                     List<String> userNames = snapshot.data ?? [];
                     if(userNames.length == 0){
                       return Text('Personnes intéressées : Personne...');
                     }else{
                       return Text('Personnes intéressées : ${userNames.join(', ')}');
                     }

                   }
                 },
               ),
             ],
            ),
          ],
        ),
      ),
    );
  }

  Future<List<String>> getUserOk(List<int>? usersOk) async {
    List<String> usersNames = [];

    await Future.forEach(usersOk as List<int>, (int userId) async {
      final userApiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs/$userId');
      final userResponse = await http.get(userApiUrl);

      if (userResponse.statusCode == 200) {
        Map<String, dynamic> userJson = json.decode(userResponse.body);
        usersNames.add('${userJson['nom']} ${userJson['prenom']}');
      } else {
        throw Exception('Failed to load user data from the API');
      }
    });

    return usersNames;
  }
}
