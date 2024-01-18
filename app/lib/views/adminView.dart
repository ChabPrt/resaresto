import 'package:flutter/material.dart';
import '../components/header.dart';
import '../components/restaurantAllItems.dart';
import '../components/toolBar.dart';

class AdminView extends StatefulWidget {
  @override
  _AdminViewState createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late int idSelectedItem;
  late int? selectedRestaurantId;

  @override
  void initState() {
    super.initState();
    selectedRestaurantId = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Header(),
          const SizedBox(height: 35.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Restaurants",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Toolbar(context: "Restaurants", idCurrentElement: selectedRestaurantId),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: RestaurantAllItems(
                      onRestaurantSelected: (int? restaurantId) {
                        setState(() {
                          selectedRestaurantId = restaurantId;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Utilisateurs",
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Toolbar(context: "Utilisateurs"),
                  ],
                ),
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.3,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: RestaurantAllItems(
                      onRestaurantSelected: (int? restaurantId) {
                        // Ne faites rien ici pour les utilisateurs
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
