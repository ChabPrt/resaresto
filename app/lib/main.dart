import 'package:app/config/app_config.dart';
import 'package:flutter/material.dart';
import 'views/connexionView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginView(),
      theme: ThemeData(
      scaffoldBackgroundColor: AppConfig.backgroundColor,
    ),
    );
  }
}