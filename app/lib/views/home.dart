import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/searchResto.dart';

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
            }
          ),
          const SizedBox(height: 35.0),
          SearchResto(),
        ],
      ),
    );
  }
}

