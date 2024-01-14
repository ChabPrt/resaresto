import 'package:app/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/wishModel.dart';

class WishCard extends StatelessWidget {
  final Wish wish;

  WishCard({required this.wish});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: AppConfig.primaryColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date de fin du vote: ${DateFormat('dd MMM').format(wish.endingVote)}'),
            Text('Créé par : ${wish.utilisateur.nom} ${wish.utilisateur.prenom}'),
            Text('Lieu : ${wish.restaurant.nom}'),
          ],
        ),
      ),
    );
  }
}
