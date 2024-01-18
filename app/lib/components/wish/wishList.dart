import 'package:app/views/homeView.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../models/wishModel.dart';
import 'wishDetails.dart';

class WishList extends StatelessWidget {
  final int idGroup;
  late int idConnectedUser;

  WishList({required this.idGroup});

  Future<void> initUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user') ?? '';

      final String apiUrl = '${AppConfig.apiBaseUrl}/Utilisateurs/Recuperer/$userEmail';
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);

        idConnectedUser = jsonData?['id'] ?? 0;
      } else {
        print('Erreur de requête API: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la requête API: $e');
    }
  }

  Future<List<Wish>> fetchProposalsByGroupId(int groupId) async {
    try {
      final response =
      await http.get(Uri.parse('${AppConfig.apiBaseUrl}/Groupes/RecupererPropositions/$groupId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        return await fetchWishesByIds(data[0]['propositions'].cast<int>());
      } else {
        throw Exception('Failed to load proposals. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load proposals: $error');
    }
  }

  Future<List<Wish>> fetchWishesByIds(List<int> wishIds) async {
    try {
      List<Future<Wish>> wishFutures = wishIds.map((wishId) => fetchWishById(wishId)).toList();
      return await Future.wait(wishFutures);
    } catch (error) {
      throw Exception('Failed to load wishes: $error');
    }
  }

  Future<Wish> fetchWishById(int wishId) async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/Propositions/$wishId'));

      if (response.statusCode == 200) {
        return Wish.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load wish with id $wishId. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load wish with id $wishId: $error');
    }
  }

  Map<String, List<Wish>> groupProposalsByDate(List<Wish> proposals) {
    Map<String, List<Wish>> groupedProposals = {};

    for (Wish proposal in proposals) {
      String date = proposal.date.toLocal().toString().split(' ')[0]; // Format de date, ajustez selon vos besoins

      groupedProposals.putIfAbsent(date, () => []);
      groupedProposals[date]!.add(proposal);
    }

    return groupedProposals;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initUserData(),
      builder: (context, initSnapshot) {
        if (initSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (initSnapshot.hasError) {
          return Center(child: Text('Error initializing user data: ${initSnapshot.error}'));
        } else {
          return FutureBuilder(
            future: fetchProposalsByGroupId(idGroup),
            builder: (context, proposalSnapshot) {
              if (proposalSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (proposalSnapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Aïe ! Aucune proposition n'a été faite pour ce groupe ...",
                        style: TextStyle(fontSize: 16.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.0),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeView()),
                          );
                        },
                        child: Text(
                          "Revenir au menu principal",
                          style: TextStyle(fontSize: 16.0, color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                List<Wish> proposals = proposalSnapshot.data as List<Wish>;
                Map<String, List<Wish>> groupedProposals = groupProposalsByDate(proposals);
                return Container(
                  height: 500.0,
                  child: ListView.builder(
                    itemCount: groupedProposals.length,
                    itemBuilder: (context, index) {
                      String date = groupedProposals.keys.elementAt(index);
                      List<Wish> proposalsForDate = groupedProposals[date]!;
                      proposalsForDate.sort((a, b) => a.date.compareTo(b.date));
                      return WishDetail(date: date, propositions: proposalsForDate, connectedUserId: idConnectedUser);
                    },
                  ),
                );
              }
            },
          );
        }
      },
    );
  }
}
