import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'package:app/views/homeView.dart';
import '../../config/app_config.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool showError = false;

  Future<void> verifyUser(String email, String password) async {
    try {
      final apiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs/Authorize?Mail=$email&Pass=$password');

      final response = await http.get(
        apiUrl,
        headers: {
          'X-Apikey': '${AppConfig.apiKey}',
        },
      );


      if (response.statusCode == 200) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String userEmail = emailController.text;
        prefs.setString('user', userEmail);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeView()),
        );
      } else {
        setState(() {
          showError = true;
        });
      }
    } catch (e) {
      print('Erreur de requête: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Adresse e-mail'),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Mot de passe'),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                setState(() {
                  showError = true;
                });
                return;
              }

              await verifyUser(emailController.text, passwordController.text);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConfig.principalColor,
              foregroundColor: AppConfig.fontWhiteColor,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 50.0, vertical: 25.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text('Valider'),
          ),
          const SizedBox(height: 20),
          showError
              ? Text(
            'Email ou mot de passe incorrect',
            style: TextStyle(color: Colors.red),
          )
              : Container(),
        ],
      ),
    );
  }
}
