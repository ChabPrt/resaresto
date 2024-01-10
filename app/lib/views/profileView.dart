import 'package:app/views/homeView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/header.dart';
import 'package:app/views/connexionView.dart';
import 'package:app/components/userProfile.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Header(
              onProfilePressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                );
              },
              onLogoutPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('user');

                // Rediriger vers la page de connexion
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                );
              }
          ),
          const SizedBox(height: 35.0),
          UserProfileScreen(),
          const SizedBox(height: 80.0),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            child: const Text("Vos groupes : ",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
        ],
      ),
    );
  }
}

