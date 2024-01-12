import 'dart:convert';

import 'package:app/config/app_config.dart';
import 'package:app/views/profileView.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import 'package:app/models/groupModel.dart';
import 'package:app/models/groupUsersModel.dart';

class GroupForm extends StatefulWidget {
  final int idUser;

  GroupForm({required this.idUser});

  @override
  _GroupFormState createState() => _GroupFormState();
}

class _GroupFormState extends State<GroupForm> {
  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Center(
        child: IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _showGroupDialog(context);
          },
        ),
      ),
    );
  }

  void _showGroupDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            height: 500.0,
            width: 500.0,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 15.0),
                        Text(
                          'Créez votre groupe',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: AppConfig.fontBlackColor
                          ),
                        ),
                        SizedBox(height: 50.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: _labelController,
                            decoration: InputDecoration(labelText: 'Libellé'),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        ElevatedButton(
                          onPressed: () {
                            Group newGroup = Group(
                              libelle: _labelController.text
                            );
                            createGroup(newGroup, widget.idUser);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileView()),
                            );

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConfig.principalColor,
                            foregroundColor: AppConfig.fontWhiteColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text('Créer'),
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: AppConfig.principalColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 15.0),
                        Text(
                          'Rejoignez vos amis',
                          style: TextStyle(
                              fontSize: 18.0,
                              color: AppConfig.fontWhiteColor
                          ),
                        ),
                        SizedBox(height: 50.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextField(
                            controller: _codeController,
                            decoration: InputDecoration(labelText: 'Code'),
                          ),
                        ),
                        SizedBox(height: 25.0),
                        ElevatedButton(
                          onPressed: () {
                            String code = _codeController.text;
                            joinGroup(code, widget.idUser);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => ProfileView()),
                            );

                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConfig.fontWhiteColor,
                            foregroundColor: AppConfig.principalColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: Text('Rejoindre'),
                        ),
                        SizedBox(height: 15.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> createGroup(Group group, int idUser) async {
    try {
      final jsonDataGroup = group.toJson();
      final jsonGroupString = jsonEncode(jsonDataGroup);

      final response = await http.post(
        Uri.parse('${AppConfig.apiBaseUrl}/Groupes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonGroupString,
      );

      if (response.statusCode == 201) {
        print('Groupe créé avec succès!');
        Map<String, dynamic> jsonData = json.decode(response.body);
        var idGroup = jsonData['id'];

        GroupUsers groupUsers = GroupUsers(idUser: idUser, idGroup: idGroup);

        jsonData = groupUsers.toJson();
        final jsonString = jsonEncode(jsonData);

        final responseLink = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/GroupeUtilisateurs'),
          headers: {'Content-Type': 'application/json'},
          body: jsonString,
        );
        if (responseLink.statusCode == 201) {
          print('Utilisateur lié au groupe !');
        }else {
          // La création du groupe a échoué, vous pouvez traiter la réponse d'erreur si nécessaire
          print('Erreur lors de la liasion de l\'utilisateur au du groupe: ${responseLink.statusCode}');
        }
      } else {
        // La création du groupe a échoué, vous pouvez traiter la réponse d'erreur si nécessaire
        print('Erreur lors de la création du groupe: ${response.statusCode}');
      }
    } catch (e) {
      // Gestion des erreurs lors de la requête
      print('Erreur lors de la création du groupe: $e');
    }
  }

  Future<void> joinGroup(String code, int idUser) async {
    try {

      final String apiUrl = '${AppConfig.apiBaseUrl}/Groupes/$code';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        var idGroup = jsonData['id'];

        GroupUsers groupUsers = GroupUsers(idUser: idUser, idGroup: idGroup);

        jsonData = groupUsers.toJson();
        final jsonString = jsonEncode(jsonData);

        final responseLink = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/GroupeUtilisateurs'),
          headers: {'Content-Type': 'application/json'},
          body: jsonString,
        );

        if (responseLink.statusCode == 201) {
          print('Utilisateur lié au groupe !');
        }else {
          // La création du groupe a échoué, vous pouvez traiter la réponse d'erreur si nécessaire
          print('Erreur lors de la liasion de l\'utilisateur au du groupe: ${responseLink.statusCode}');
        }
      } else {
        // Rejoindre le groupe a échoué, vous pouvez traiter la réponse d'erreur si nécessaire
        print('Groupe introuvable pour le code: ${response.statusCode}');
      }
    } catch (e) {
      // Gestion des erreurs lors de la requête
      print('Erreur de recupperation du groupe: $e');
    }
  }
}
