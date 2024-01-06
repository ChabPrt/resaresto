import 'package:flutter/material.dart';
import '../components/loginForm.dart';

void main() {
  runApp(loginView());
}

class loginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
        children: [
          LoginScreen(),
        ]
      )
    );
  }
}