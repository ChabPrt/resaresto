import 'package:app/config/app_config.dart';
import 'package:flutter/material.dart';

class GroupCard extends StatelessWidget {
  final String title;
  final String code;
  final List<String> users;

  GroupCard({required this.title, required this.code, required this.users});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      color: AppConfig.primaryColor,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Titre: $title'),
            Text('Code: $code'),
            Text('Utilisateurs: ${users.join(', ')}'),
          ],
        ),
      ),
    );
  }
}