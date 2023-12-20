import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppConfig {
  static const String appName = "RésaResto";

  // Utilisation de Google Fonts
  static final TextStyle headingStyle = GoogleFonts.roboto(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: fontPrimaryColor,
  );

  // URL de base pour les requêtes API
  static const String apiBaseUrl = "LATER";

  // Clé d'API pour les services externes
  static const String apiKeyGoogle = "LATER";

  // Couleurs de l'application
  static const primaryColor = const Color(0xffbb3b0e);
  static const secondaryColor = const Color(0xffdd7631);
  static const tertiaryColor = const Color(0xffd8c593);
  static const quaternaryColor = const Color(0xff708160);

  static const validPrimaryColor = const Color(0xff4dff3c);
  static const validSecondaryColor = const Color(0xff41b935);

  static const warningPrimaryColor = const Color(0xffffdd24);
  static const warningSecondaryColor = const Color(0xffdebf2c);

  static const infoPrimaryColor = const Color(0xff44b1ff);
  static const infoSecondaryColor = const Color(0xff2c94de);

  static const errorPrimaryColor = const Color(0xfff33131);
  static const errorSecondaryColor = const Color(0xffa42121);

  static const fontPrimaryColor = const Color(0xff000000);
  static const fontSecondaryColor = const Color(0xffefefef);
}