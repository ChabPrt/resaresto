import 'package:app/config/app_config.dart';
import 'package:flutter/material.dart';
import 'views/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: loginView(),
      theme: ThemeData(
      // Change the background color here
      scaffoldBackgroundColor: AppConfig.backgroundColor, // Replace 'Colors.blue' with your desired color
    ),
    );
  }
}