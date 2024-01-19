import 'package:flutter/material.dart';
import '../components/connexion/loginForm.dart';
import '../components/connexion/registerForm.dart';
import '../config/app_config.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final String title = AppConfig.appName;
  bool isLogin = true;

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
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                height: MediaQuery.of(context).size.height * 0.8,
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
                      isLogin ? "Connexion" : "Inscription",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 80.0),
                      child: isLogin ? LoginScreen() : RegistrationScreen(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isLogin
                            ? const Text('Pas encore de compte ?')
                            : const Text('Vous êtes déjà inscrit ?'),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isLogin = !isLogin;
                            });
                          },
                          child: Text(isLogin ? 'Inscrivez-vous !' : 'Connectez-vous !'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          ),
          ),
        ]
      ),
    );
  }
}
