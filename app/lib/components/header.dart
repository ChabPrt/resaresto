import 'package:app/config/app_config.dart';
import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title = AppConfig.appName;
  final VoidCallback onProfilePressed;

  Header({required this.onProfilePressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppConfig.principalColor,
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppConfig.fontWhiteColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Lumanosimo',
            ),
            textAlign: TextAlign.left,
          ),
          Expanded(
            child: Container(), // Espace extensible pour pousser l'icône utilisateur à droite
          ),
          GestureDetector(
            onTap: onProfilePressed,
            child: const CircleAvatar(
              backgroundImage: AssetImage("assets/img/user_default_icon.jpg"),
            ),
          ),
        ],
      ),
    );
  }
}
