import 'dart:convert';

import 'package:app/models/wishModel.dart';
import 'package:app/models/groupModel.dart';
import 'package:app/models/groupWishModel.dart';
import 'package:app/views/profileView.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app/config/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/restaurantModel.dart';
import 'package:http/http.dart' as http;

import '../../views/loginView.dart';

class WishForm extends StatefulWidget {
  final Restaurant restaurant;
  final String date;

  const WishForm({required this.restaurant, required this.date});

  @override
  _WishFormState createState() => _WishFormState();
}

class _WishFormState extends State<WishForm> {
  late String _selectedDate;
  late int idUser;
  int? _selectedGroupId;

  final TextEditingController _dateController = TextEditingController();
  List<Group> _groupList = [];
  bool _groupsFetched = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date;
    _dateController.text = _selectedDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    if (!_groupsFetched) {
      await _fetchGroups();
      setState(() {
        _groupsFetched = true;
      });
    }

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy').parse(_selectedDate),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != DateFormat('dd/MM/yyyy').parse(_selectedDate)) {
      setState(() {
        _selectedDate = DateFormat('dd/MM/yyyy').format(picked);
        _dateController.text = _selectedDate;
      });
    }
  }

  Future<void> _fetchGroups() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userEmail = prefs.getString('user') ?? '';

      if (userEmail.isEmpty) {
        Navigator.of(context as BuildContext).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginView()),
        );
        throw Exception('User email is empty');
      }

      final String userApiUrl = '${AppConfig.apiBaseUrl}/Utilisateurs/Recuperer/$userEmail';
      final userResponse = await http.get(Uri.parse(userApiUrl),
        headers: {
          'X-Apikey': '${AppConfig.apiKey}',
        },);

      if (userResponse.statusCode == 200) {
        Map<String, dynamic> userData = json.decode(userResponse.body);
        idUser = userData['id'];

        final groupListResponse = await http.get(Uri.parse('${AppConfig.apiBaseUrl}/Groupes/RecupererUsers/$idUser'),
          headers: {
            'X-Apikey': '${AppConfig.apiKey}',
          },);

        if (groupListResponse.statusCode == 200) {
          final List<dynamic> groupUsersJsonList = json.decode(groupListResponse.body);

          List<Group> groups = groupUsersJsonList.map<Group>((groupJson) {
            return Group(
              id: groupJson['id'],
              libelle: groupJson['libelle'],
            );
          }).toList();

          setState(() {
            _groupList = groups;
          });
        } else {
          throw Exception('Failed to load proposals. Status code: ${groupListResponse.statusCode}');
        }
      } else {
        throw Exception('Failed to load data from the API');
      }
    } catch (error) {
      throw Exception('Failed to load proposals: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Dialog(
        child: Container(
          height: 500.0,
          width: 500.0,
          child: Column(
            children: [
              Text(
                'Votre proposition : ',
                style: const TextStyle(
                  fontSize: 20.0,
                  color: AppConfig.fontBlackColor,
                ),
              ),
              Text(
                'Le restaurant : ${widget.restaurant.nom}',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: AppConfig.fontBlackColor,
                ),
              ),
              Text(
                'Situé à : ${widget.restaurant.adresse}',
                style: const TextStyle(
                  fontSize: 18.0,
                  color: AppConfig.fontBlackColor,
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Text(
                    'Pour le midi du : ',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: AppConfig.fontBlackColor,
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => _selectDate(context),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _dateController,
                          decoration: const InputDecoration(
                            labelText: 'Sélectionner une date...',
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 35.0),
              Row(
                children: [
                  Text(
                    'Groupe à inviter :',
                    style: const TextStyle(
                      fontSize: 18.0,
                      color: AppConfig.fontBlackColor,
                    ),
                  ),
                  Expanded(
                    child:  DropdownButtonFormField<int>(
                      onTap: () {

                      },
                      value: _selectedGroupId,
                      onChanged: (int? newValue) {
                        setState(() {
                          _selectedGroupId = newValue;
                        });
                      },
                      items: _groupList.map<DropdownMenuItem<int>>((Group group) {
                        return DropdownMenuItem<int>(
                          value: group.id,
                          child: Text(group.libelle),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Sélectionner un groupe ... ',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.fontWhiteColor,
                      foregroundColor: AppConfig.principalColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Annuler'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Wish newProposition = Wish(
                        id: 0,
                        date: DateFormat('dd/MM/yyyy').parse(_dateController.text),
                        endingVote: DateFormat('dd/MM/yyyy').parse(_dateController.text).add(Duration(days: 1)),
                        restaurantId: widget.restaurant.id ?? 0,
                        utilisateurId: idUser,
                        usersOk: [],
                      );
                      saveProposition(newProposition, _selectedGroupId);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileView()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.principalColor,
                      foregroundColor: AppConfig.fontWhiteColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Accepter'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveProposition(newProposition, idGroup) async {
    final apiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Propositions');

    try {
      final jsonData = newProposition.toJson();
      final jsonString = jsonEncode(jsonData);

      final response = await http.post(
        apiUrl,
        headers: {
          'X-Apikey': '${AppConfig.apiKey}',
        },
        body: jsonString,
      );

      if (response.statusCode == 201) {
        print('Ajout de la proposition réussie');
        Map<String, dynamic> jsonData = json.decode(response.body);
        var idProposition = jsonData['id'];

        GroupWish groupUsers = GroupWish(idProposition: idProposition, idGroup: idGroup);

        jsonData = groupUsers.toJson();
        final jsonString = jsonEncode(jsonData);

        final responseLink = await http.post(
          Uri.parse('${AppConfig.apiBaseUrl}/GroupePropositions'),
          headers: {
            'X-Apikey': '${AppConfig.apiKey}',
          },
          body: jsonString,
        );
        if (responseLink.statusCode == 201) {
          print('Utilisateur lié au groupe !');
        }else {
          // La création du groupe a échoué, vous pouvez traiter la réponse d'erreur si nécessaire
          print('Erreur lors de la liasion de l\'utilisateur au du groupe: ${responseLink.statusCode}');
        }
      } else {
        print(jsonString);
        print('Erreur lors de l\'ajout de la proposition : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de requête: $e');
    }
  }
}
