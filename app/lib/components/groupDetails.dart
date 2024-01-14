import 'package:flutter/material.dart';
import '../config/app_config.dart';

class GroupDetails extends StatelessWidget {
  final int idGroup;
  final String title;
  final String code;
  final List<String> users;

  GroupDetails({required this.idGroup, required this.title, required this.code, required this.users});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.width * 0.9,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop(); // Cela fermera la fenêtre de dialogue
                },
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 15.0),
                    Text(
                      '${title}',
                      style: TextStyle(
                          fontSize: 18.0,
                          color: AppConfig.fontBlackColor
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Code: $code'),
                        SizedBox(width: 30.0),
                        Text('Utilisateurs: ${users.join(', ')}'),],
                    ),
                    SizedBox(height: 50.0),
                    Text("Les propositions du groupe : "),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
