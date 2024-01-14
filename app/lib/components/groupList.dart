import 'dart:convert';
import 'dart:js';
import 'package:app/components/groupForm.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';

import '../views/connexionView.dart';
import '../components/groupCard.dart';

class GroupList extends StatelessWidget {
  final List<GroupCard> groupCards;
  final GroupForm groupForm;

  GroupList({required this.groupCards, required this.groupForm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: groupCards.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index == groupCards.length) {
              return groupForm;
            } else {
              return groupCards[index];
            }
          },
        ),
      ),
    );
  }
}

class GroupListCards extends StatelessWidget {
  late int idUser;

  Future<List<GroupCard>> fetchGroupList() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user') ?? '';

      if (userEmail.isEmpty) {
        Navigator.of(context as BuildContext).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginView()),
        );
        throw Exception('User email is empty');
      }

      final String userApiUrl = '${AppConfig.apiBaseUrl}/Utilisateurs/Recuperer/$userEmail';
      final userResponse = await http.get(Uri.parse(userApiUrl));

      if (userResponse.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(userResponse.body);
        idUser = userData['id'];

        final groupListApiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Groupes/RecupererUsers/$idUser');
        final groupListResponse = await http.get(groupListApiUrl);

        if (groupListResponse.statusCode == 200) {
          final List<dynamic> groupUsersJsonList = json.decode(groupListResponse.body);

          List<GroupCard> groupCards = await Future.wait(groupUsersJsonList.map((jsonGroupUser) async {
            List<String> usersNames = [];

            await Future.forEach(jsonGroupUser['utilisateurs'] as List<dynamic>, (userId) async {
              final userApiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs/$userId');
              final userResponse = await http.get(userApiUrl);

              if (userResponse.statusCode == 200) {
                Map<String, dynamic> userJson = json.decode(userResponse.body);
                usersNames.add('${userJson['nom']} ${userJson['prenom']}');
              } else {
                throw Exception('Failed to load user data from the API');
              }
            });

            return GroupCard(
              idGroup: jsonGroupUser["id"],
              title: jsonGroupUser["libelle"],
              code: jsonGroupUser["code"],
              users: usersNames,
            );
          }).toList());

          return groupCards;
        } else {
          throw Exception('Failed to load data from the API');
        }
      } else {
        throw Exception('API request failed with status code ${userResponse.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during API request: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchGroupList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error loading data'),
          );
        } else {
          List<GroupCard> groupCards = snapshot.data as List<GroupCard>;
          GroupForm groupForm = GroupForm(idUser: idUser);
          return GroupList(groupCards: groupCards, groupForm: groupForm);
        }
      },
    );
  }
}
