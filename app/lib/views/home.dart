import 'package:flutter/material.dart';
import '../components/searchResto.dart';

class HomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SearchResto(),
        ],
      ),
    );
  }
}

