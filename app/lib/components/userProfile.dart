import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/app_config.dart';
import 'package:app/components/userProfileForm.dart';
import 'package:app/views/connexionView.dart';

import '../models/userModel.dart';

class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: UserProfile(),
    );
  }
}

class UserProfile extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfile> {
  late String sourceProfilImage = "assets/img/user_default_icon.jpg";
  late Future<User> userDataFuture;
  late bool showEditPopup = false;
  late int idUser;

  @override
  void initState() {
    super.initState();
    userDataFuture = initUserData();
  }

  Future<User> initUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user') ?? '';

      if (userEmail.isEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginView()),
        );
        throw Exception('User email is empty');
      }

      final String apiUrl = '${AppConfig.apiBaseUrl}/Utilisateurs/Recuperer/$userEmail';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        idUser = jsonData['id'];
        return User.fromJson(jsonData);
      } else {
        print('Erreur de requête API: ${response.statusCode}');
        throw Exception('API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la requête API: $e');
      throw Exception('Error during API request: $e');
    }
  }

  void showEditPopupFunction(User userData, int idUser) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        print(idUser);
        return UserProfileFormPopup(userData: userData, idUser: idUser);
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: FutureBuilder<User>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No user data available'));
          } else {
            final userData = snapshot.data!;
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 100.0, right: 16.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: userData.image != ""
                        ? Image.network(userData.image!).image
                        : AssetImage('assets/img/user_default_icon.jpg'),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 50.0, top: 25.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Bonjour ${userData.nom} ${userData.prenom} !",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: AppConfig.fontBlackColor,
                        ),
                      ),
                    ],
                  )),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => showEditPopupFunction(userData, idUser),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
