import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../config/app_config.dart';
import '../../models/userModel.dart';
import '../../views/adminView.dart';

class UserAdminForm extends StatefulWidget {
  final int idUser;

  UserAdminForm({required this.idUser});

  @override
  _UserAdminFormState createState() => _UserAdminFormState();
}

class _UserAdminFormState extends State<UserAdminForm> {
  late Future<User> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = getSelectedUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Erreur de chargement des données: ${snapshot.error}');
        } else {
          if (snapshot.data!.levelAcces == 1) {
            return _buildAdminAlreadyExistsDialog(snapshot.data!);
          } else {
            return _buildAlertDialog(snapshot.data!);
          }
        }
      },
    );
  }

  Widget _buildAdminAlreadyExistsDialog(User userData) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text('Information'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'L\'utilisateur ${userData.nom} ${userData.prenom} est déjà administrateur !',
            style: TextStyle(fontSize: 16.0),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Retour'),
        ),
      ],
    );
  }

  Widget _buildAlertDialog(User userData) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      title: Text('Confirmation'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Êtes-vous sûr d\'augmenter les droits de l\'utilisateur ${userData.nom} ${userData.prenom}?',
            style: TextStyle(fontSize: 16.0),
          ),
          SizedBox(height: 20.0),
          Text(
            'Cette action sera irréversible!',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Non'),
        ),
        ElevatedButton(
          onPressed: () {
            updateUserAcces(context);
          },
          child: Text('Oui'),
        ),
      ],
    );
  }

  Future<User> getSelectedUser() async {
    try {
      final String apiUrl = '${AppConfig.apiBaseUrl}/Utilisateurs/${widget.idUser}';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'X-Apikey': '${AppConfig.apiKey}',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
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

  Future<void> updateUserAcces(BuildContext context) async {
    final apiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs/Upgrade/${widget.idUser}');

    try {
      final emptyJSON = jsonEncode({});

      final response = await http.put(
        apiUrl,
        headers: {
          'X-Apikey': '${AppConfig.apiKey}',
          'Content-Type': 'application/json',
        },
        body: emptyJSON,
      );

      if (response.statusCode == 200) {
        print('Mise à jour des droits utilisateurs réussie');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminView()),
        );
      } else {
        print('Erreur lors de la mise à jour des droits : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de requête: $e');
    }
  }
}
