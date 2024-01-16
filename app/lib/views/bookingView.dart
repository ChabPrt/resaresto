import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/restaurantList.dart';
import '../components/header.dart';
import '../views/homeView.dart';
import '../views/loginView.dart';

class BookingView extends StatelessWidget {
  final String address;
  final String date;

  BookingView({required this.address, required this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginView()),
              );
            },
          ),
          const SizedBox(height: 35.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              "Les restaurants de $address",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20.0),
          Expanded(
            child: RestaurantList(address: address, date: date),
          ),
        ],
      ),
    );
  }
}
