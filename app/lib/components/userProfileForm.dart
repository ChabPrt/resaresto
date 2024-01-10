import 'dart:convert';
import 'package:app/config/app_config.dart';
import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../views/profileView.dart';

class UserProfileFormPopup extends StatelessWidget {
  final User userData;
  final int idUser;

  UserProfileFormPopup({required this.userData, required this.idUser});

  @override
  Widget build(BuildContext context) {
    final TextEditingController profileImageController = TextEditingController(text: userData.image);
    final TextEditingController lastNameController = TextEditingController(text: userData.nom);
    final TextEditingController firstNameController = TextEditingController(text: userData.prenom);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la popup
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: profileImageController.text != ""
                          ? Image.network(profileImageController.text).image
                          : AssetImage('assets/img/user_default_icon.jpg'),
                    ),
                  ),
                  TextField(
                    controller: profileImageController,
                    decoration: InputDecoration(labelText: 'URL de l\'image'),
                  ),
                  TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(labelText: 'Nom'),
                  ),
                  TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(labelText: 'Prénom'),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      User updatedUser = User(
                        id: userData.id,
                        nom: lastNameController.text,
                        prenom: firstNameController.text,
                        mail: userData.mail,
                        pass: userData.pass,
                        image: profileImageController.text,
                        levelAcces: userData.levelAcces
                      );
                      updateUser(context, updatedUser);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.principalColor,
                      foregroundColor: AppConfig.fontWhiteColor,
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 50.0, vertical: 25.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text('Modifier'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateUser(BuildContext context, User user) async {
    final apiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs/${idUser}');

    try {
      final jsonString = jsonEncode(user);

      print(jsonString);
      final response = await http.put(
        apiUrl,
        headers: {'Content-Type': 'application/json'},
        body: jsonString,
      );

      if (response.statusCode == 200) {
        print('Inscription réussie');

        //Pb de retour arrière
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => ProfileView()),
        );
      } else {
        print(jsonString);
        print('Erreur lors de l\'inscription: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de requête: $e');
    }
  }
}
