import 'dart:js';

import 'package:app/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'groupDetails.dart';

class GroupCard extends StatelessWidget {
  final int idGroup;
  final String title;
  final String code;
  final List<String> users;

  GroupCard({required this.idGroup, required this.title, required this.code, required this.users});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return GroupDetails(
              idGroup: idGroup,
              title: title,
              code: code,
              users: users,
            );
          },
        );
      },
      child: Card(
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
              IconButton(
                icon: Icon(Icons.content_copy),
                onPressed: () {
                  _copyToClipboard('$code');
                },
                tooltip: 'Copier dans le Presse-papiers',
              ),
              Text('Utilisateurs: ${users.join(', ')}'),
            ],
          ),
        ),
      ),
    );
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(
        content: Text('Code copié dans le presse-papiers'),
      ),
    );
  }
}
