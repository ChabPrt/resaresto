import 'package:flutter/material.dart';
import '../config/app_config.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/wishModel.dart';
import '../components/wishDetails.dart';

class WishList extends StatelessWidget {
  final int idGroup;

  WishList({required this.idGroup});

  Future<List<Wish>> fetchProposalsByGroupId(int groupId) async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/Groupes/RecupererPropositions/$groupId'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Assurez-vous que vos propositions sont chargées correctement depuis leur route respective
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

      if (!groupedProposals.containsKey(date)) {
        groupedProposals[date] = [];
      }

      groupedProposals[date]!.add(proposal);
    }

    return groupedProposals;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchProposalsByGroupId(idGroup),
      builder: (context, proposalSnapshot) {
        if (proposalSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (proposalSnapshot.hasError) {
          return Center(child: Text('Error loading proposal data: ${proposalSnapshot.error}'));
        } else {
          List<Wish> proposals = proposalSnapshot.data as List<Wish>;

          // Group proposals by date
          Map<String, List<Wish>> groupedProposals = groupProposalsByDate(proposals);

          return Container( // Wrap with a Container
            height: 500.0, // Set a specific height or adjust as needed
            child: ListView.builder(
              itemCount: groupedProposals.length,
              itemBuilder: (context, index) {
                String date = groupedProposals.keys.elementAt(index);
                List<Wish> proposalsForDate = groupedProposals[date]!;

                return WishDetail(date: date, propositions: proposalsForDate);
              },
            ),
          );
        }
      },
    );
  }
}
