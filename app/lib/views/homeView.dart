import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/searchResto.dart';
import '../components/reviewsHome.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Header(
            isHomePage: true,
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

