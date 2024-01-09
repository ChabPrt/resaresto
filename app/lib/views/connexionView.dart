import 'package:flutter/material.dart';
import '../components/loginForm.dart';
import 'package:app/components/registerForm.dart';

import '../config/app_config.dart';

class LoginView extends StatelessWidget {
  final String title = AppConfig.appName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/background_search.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.6,
              child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    color: AppConfig.principalColor,
                    child: Center(
                      child: Text(
                        title,
                        style: const TextStyle(
                          color: AppConfig.fontWhiteColor,
                          fontSize: 50.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Lumanosimo',
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    color: AppConfig.backgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Connexion",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20.0),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 80.0),
                            //child: LoginScreen(),
                            child: RegistrationScreen(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}