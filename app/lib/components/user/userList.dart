import 'package:app/components/user/userCard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../config/app_config.dart';
import '../../models/userModel.dart';

class UserList extends StatefulWidget {
  final void Function(int?) onUserSelected;

  UserList({required this.onUserSelected});

  Future<List<User>> fetchUsers() async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/Utilisateurs'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<User> users = data.map((json) => User.fromJson(json)).toList();

        return users;
      } else {
        throw Exception('Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load users: $error');
    }
  }

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  int? selectedUserId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.fetchUsers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error loading user data: ${snapshot.error}'));
        } else {
          List<User> users = snapshot.data as List<User>;

          if (users.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Oups ! Aucun user n'a été trouvé. Veuilliez en créer.",
                    style: TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.0),
                ],
              ),
            );
          }

          return Container(
            height: 500.0,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                User user = users[index];
                return UserCard(
                  user: user,
                  isSelected: selectedUserId == user.id,
                  onCardSelected: (int userId) {
                    setState(() {
                      if (selectedUserId == userId) {
                        selectedUserId = null;
                      } else {
                        selectedUserId = userId;
                      }
                    });

                    widget.onUserSelected(selectedUserId);
                  },
                );
              },
            ),
          );
        }
      },
    );
  }
}
