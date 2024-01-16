import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/app_config.dart';
import 'package:app/views/loginView.dart';

class Header extends StatefulWidget {
  final VoidCallback onProfilePressed;
  final VoidCallback onLogoutPressed;

  Header({required this.onProfilePressed, required this.onLogoutPressed});

  @override
  _HeaderState createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  late int levelAcces = 0;
  late String sourceProfilImage = "assets/img/user_default_icon.jpg";
  final String title = AppConfig.appName;
  late Future<void> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = initUserData();
  }

  Future<void> initUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user') ?? '';

      if (userEmail.isEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginView()),
        );
        return;
      }

      final String apiUrl = '${AppConfig.apiBaseUrl}/Utilisateurs/Recuperer/$userEmail';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        setState(() {
          levelAcces = jsonData?['levelAcces'] ?? 0;
          sourceProfilImage = (jsonData?['image'] ?? "").isEmpty
              ? "assets/img/user_default_icon.jpg"
              : jsonData?['image'];
        });
      } else {
        print('Erreur de requête API: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la requête API: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppConfig.principalColor,
      ),
      child: FutureBuilder(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppConfig.fontWhiteColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Lumanosimo',
                  ),
                  textAlign: TextAlign.left,
                ),
                Expanded(
                  child: Container(),
                ),
                if (levelAcces == 1)
                  GestureDetector(
                    onTap: widget.onProfilePressed,
                    child: const Icon(
                      Icons.settings,
                      color: AppConfig.fontWhiteColor,
                      size: 30.0,
                    ),
                  ),
                if (levelAcces == 1) SizedBox(width: 10.0),
                GestureDetector(
                  onTap: widget.onProfilePressed,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(sourceProfilImage),
                  ),
                ),
                SizedBox(width: 10.0),
                GestureDetector(
                  onTap: widget.onLogoutPressed,
                  child: const Icon(
                    Icons.exit_to_app,
                    color: AppConfig.fontWhiteColor,
                    size: 30.0,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
