import 'dart:convert';

import 'package:app/models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../config/app_config.dart';

class RegistrationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RegistrationForm(),
    );
  }
}

class RegistrationForm extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController profileImageController = TextEditingController();

  Future<void> saveUser(User user) async {
    final apiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs');

    try {
      final jsonData = user.toJson();
      final jsonString = jsonEncode(jsonData);

      final response = await http.post(
        apiUrl,
        headers: {
          'X-Apikey': '${AppConfig.apiKey}',
          'Content-Type': 'application/json'
        },
        body: jsonString,
      );

      if (response.statusCode == 201) {
        print('Inscription réussie');
      } else {
        print(jsonString);
        print('Erreur lors de l\'inscription: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de requête: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Adresse e-mail'),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Mot de passe'),
          ),
          TextField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
                labelText: 'Vérification du mot de passe'),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              User newUser = User(
                id: 0,
                nom: lastNameController.text,
                prenom: firstNameController.text,
                mail: emailController.text,
                pass: passwordController.text,
                levelAcces: 0,
                image: profileImageController.text,
              );
              saveUser(newUser);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConfig.principalColor,
              foregroundColor: AppConfig.fontWhiteColor,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 50.0, vertical: 25.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Text('Valider'),
          ),
        ],
      ),
    );
  }
}
