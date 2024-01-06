import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/header.dart';
import '../components/searchResto.dart';
import '../components/reviewsHome.dart';
import 'package:app/views/login.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Header(
            onProfilePressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchResto()),
              );
            },
            onLogoutPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.remove('user'); // Supprimer l'e-mail stocké

              // Rediriger vers la page de connexion
              Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => loginView()),
              );
            }
          ),
          const SizedBox(height: 35.0),
          SearchResto(),
          const SizedBox(height: 80.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: const Text("Les avis du moment : ",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          ReviewsHomeWrapper()
        ],
      ),
    );
  }
}

