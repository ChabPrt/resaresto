import 'package:app/components/restaurant/restaurantForm.dart';
import 'package:app/components/user/userAdminForm.dart';
import 'package:app/views/adminView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/app_config.dart';

class Toolbar extends StatefulWidget {
  final bool create;
  final bool edit;
  final bool remove;
  final String context;
  final int? idCurrentElement;

  Toolbar({this.create = true, this.edit = true, this.remove = true, required this.context, this.idCurrentElement});

  @override
  _ToolbarState createState() => _ToolbarState();
}

class _ToolbarState extends State<Toolbar> {
  late String methodeCall;


  bool isValidId(String methodeCall) {

    print(widget.idCurrentElement);
    if(methodeCall == "create") return true;

    return widget.idCurrentElement != null && widget.idCurrentElement != 0;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (widget.create) {
      children.add(
        GestureDetector(

          child: Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  if (isValidId("create")) {
                    if(widget.context == "Restaurants") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RestaurantForm();
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ),
      );
    }

    if (widget.edit) {
      children.add(
        GestureDetector(

          child: Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  if (isValidId("edit")) {
                    if(widget.context == "Restaurants") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return RestaurantForm(idRestaurant: widget.idCurrentElement);
                        },
                      );
                    }

                    if(widget.context == "Utilisateurs") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return UserAdminForm(idUser: widget.idCurrentElement ?? 0);
                        },
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ),
      );
    }

    if (widget.remove) {
      children.add(
        GestureDetector(

          child: Card(
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  if (isValidId("remove")) {
                    if(widget.context == "Restaurants") deleteRestaurant(context, widget.idCurrentElement ?? 0);
                  }
                },
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: children,
      ),
    );
  }

  Future<void> deleteRestaurant(BuildContext context, int idRestaurant) async {
    final apiUrl = Uri.parse(
        '${AppConfig.apiBaseUrl}/Restaurants/${idRestaurant}');

    try {
      final response = await http.delete(
        apiUrl,
        headers: {
          'X-Apikey': '${AppConfig.apiKey}'
        },
      );

      if (response.statusCode == 200) {
        print('Suppression réussite');

        //Pb de retour arrière
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminView()),
        );
      } else {
        print('Erreur lors de la suppression: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de requête: $e');
    }
  }
}


