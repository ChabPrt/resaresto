import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/app_config.dart';
import 'package:app/views/login.dart';

class Header extends StatelessWidget {
  final String title = AppConfig.appName;
  final VoidCallback onProfilePressed;
  final VoidCallback onLogoutPressed;

  Header({required this.onProfilePressed, required this.onLogoutPressed});

  Future<String> getUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user') ?? ''; // Retourne une chaîne vide si l'e-mail n'est pas présent
  }

  Future<String> getUserImageLink(String userEmail) async {
    // Charger le fichier users.json (ajustez le chemin selon votre structure de projet)
    String usersJsonString = await rootBundle.loadString('../data/users.json');
    Map<String, dynamic> jsonData = json.decode(usersJsonString);

    // Rechercher l'utilisateur correspondant à l'e-mail
    var usersList = jsonData['Users'] as List;
    var userData = usersList.firstWhere((user) => user['mail'] == userEmail, orElse: () => null);

    // Retourner le lien d'image de l'utilisateur ou un lien par défaut si non trouvé
    return userData != null ? userData['image'] ?? 'assets/img/user_default_icon.jpg' : 'assets/img/user_default_icon.jpg';

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppConfig.principalColor,
      ),
      child: FutureBuilder(
        future: getUserEmail(),
        builder: (context, snapshotEmail) {
          if (snapshotEmail.connectionState == ConnectionState.waiting) {
            // Retourner un widget de chargement si nécessaire
            return CircularProgressIndicator();
          } else {
            String userEmail = snapshotEmail.data.toString();

            if (userEmail.isEmpty) {
              // L'e-mail n'est pas présent, rediriger vers le formulaire de connexion
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => loginView()),
              );
              return Container(); // Retourner un conteneur vide car la redirection a été effectuée
            }

            return FutureBuilder(
              future: getUserImageLink(userEmail),
              builder: (context, snapshotImageLink) {
                if (snapshotImageLink.connectionState == ConnectionState.waiting) {
                  // Retourner un widget de chargement si nécessaire
                  return CircularProgressIndicator();
                } else {
                  String userImageLink = snapshotImageLink.data.toString();

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
                      GestureDetector(
                        onTap: onProfilePressed,
                        child: CircleAvatar(
                          backgroundImage: AssetImage(userImageLink),
                        ),
                      ),
                      SizedBox(width: 10.0), // Ajoutez une marge de 10.0 unités entre l'image de profil et le logo de déconnexion
                      GestureDetector(
                        onTap: onLogoutPressed,
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
            );
          }
        },
      ),
    );
  }
}
