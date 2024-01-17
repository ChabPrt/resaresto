import 'package:flutter/material.dart';
import '../config/app_config.dart';
import '../models/wishModel.dart';
import 'WishCard.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class WishDetail extends StatefulWidget {
  final String date;
  final List<Wish> propositions;
  final int connectedUserId;

  WishDetail({required this.date, required this.propositions, required this.connectedUserId});

  @override
  _WishDetailState createState() => _WishDetailState();
}

class _WishDetailState extends State<WishDetail> {
  late Wish selectedWish;
  Wish? correspondingWish;

  void handleWishTap(Wish proposition) async {
    correspondingWish = null;
    selectedWish = proposition;

    for (Wish wish in widget.propositions) {
      if (wish.usersOk?.contains(widget.connectedUserId) ?? false) {
        correspondingWish = wish;
        break;
      }
    }

    if (correspondingWish != null) {
      if (selectedWish.id == correspondingWish!.id) {
        // If the selectedWish is the same as correspondingWish, remove the user from usersOk
        correspondingWish!.usersOk?.remove(widget.connectedUserId);

        final response = await http.put(
          Uri.parse('${AppConfig.apiBaseUrl}/Propositions/${correspondingWish!.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(correspondingWish!.toJson()),
        );

        if (response.statusCode == 200) {
          print('Requête de suppression de l\'utilisateur de l\'ancienne proposition réussie');
          setState(() {}); // Trigger a rebuild
        } else {
          print('Erreur lors de la requête de suppression de l\'utilisateur de l\'ancienne proposition : ${response.statusCode}');
        }
      } else {
        correspondingWish!.usersOk?.remove(widget.connectedUserId);

        final response = await http.put(
          Uri.parse('${AppConfig.apiBaseUrl}/Propositions/${correspondingWish!.id}'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(correspondingWish!.toJson()),
        );

        if (response.statusCode == 200) {
          print('Requête de suppression de l\'utilisateur de l\'ancienne proposition réussie');
          setState(() {}); // Trigger a rebuild
          updateUsersOk(selectedWish!, widget.connectedUserId);
        } else {
          print('Erreur lors de la requête de suppression de l\'utilisateur de l\'ancienne proposition : ${response.statusCode}');
        }
      }
    } else {
      setState(() {}); // Trigger a rebuild
      updateUsersOk(selectedWish!, widget.connectedUserId);
    }
  }

  Future<void> updateUsersOk(Wish wishIdSelected, int connectedUserId) async {
    Wish? wishToUpdate = widget.propositions.firstWhere((wish) => wish.id == wishIdSelected.id);

    if (wishToUpdate != null) {
      wishToUpdate.usersOk?.add(connectedUserId);

      final response = await http.put(
        Uri.parse('${AppConfig.apiBaseUrl}/Propositions/${wishToUpdate.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(wishToUpdate.toJson()),
      );

      if (response.statusCode == 200) {
        print('Requête ajout de l\'utilisateur actif dans la proposition ${wishToUpdate.id} réussie');
        setState(() {}); // Trigger a rebuild
        // Add any additional logic or state updates if needed
      } else {
        print('Erreur lors de l\'ajout de l\'utilisateur actif dans la proposition : ${response.statusCode}');
      }
    } else {
      print('Wish avec l\'ID ${wishIdSelected.id} non trouvé.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        Text(
          widget.date,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        ...widget.propositions.map((proposition) {
          bool isUserOk = proposition.usersOk?.contains(widget.connectedUserId) ?? false;

          return GestureDetector(
            onTap: () {
              handleWishTap(proposition);
            },
            child: Row(
              children: [
                Icon(
                  isUserOk ? Icons.check_box : Icons.check_box_outline_blank,
                  color: isUserOk ? Colors.green : null,
                ),
                SizedBox(width: 8.0),
                WishCard(wish: proposition),
              ],
            ),
          );
        }),
      ],
    );
  }
}
