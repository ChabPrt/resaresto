import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/views/home.dart';
import './registerForm.dart';


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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'Password'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Valider les champs du formulaire
              if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                setState(() {
                  showError = true;
                });
                return;
              }

              String usersData = await rootBundle.loadString('../data/users.json');
              Map<String, dynamic> jsonData = json.decode(usersData);

              // Vérifier l'existence de l'utilisateur
              List<dynamic> usersList = jsonData['Users'];
              bool userExists = usersList.any((user) =>
              user['mail'] == emailController.text && user['pass'] == passwordController.text);

              if (userExists) {
                // Ajouter le mécanisme de "cookie" en utilisant SharedPreferences
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('user', emailController.text);

                // Rediriger l'utilisateur vers la page HomeView
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeView()),
                );
              } else {
                // Afficher une erreur si l'utilisateur n'existe pas
                setState(() {
                  showError = true;
                });
              }

            },
            child: Text('Login'),
          ),
          SizedBox(height: 20),
          showError
              ? Text(
            'Email ou mot de passe incorrect',
            style: TextStyle(color: Colors.red),
          )
              : Container(),
          SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationScreen()),
              );
            },
            child: Text('Create an account'),
          ),
        ],
      ),
    );
  }
}
