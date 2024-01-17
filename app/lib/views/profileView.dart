import 'package:flutter/material.dart';
import '../components/groupList.dart';
import '../components/header.dart';
import '../components/userProfile.dart';

class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,  // Aligner les éléments à gauche
        children: [
          Header(),
          const SizedBox(height: 35.0),
          UserProfileScreen(),
          const SizedBox(height: 80.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: const Text(
              "Vos groupes : ",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: GroupListCards(),
          ),
        ],
      ),
    );
  }
}
