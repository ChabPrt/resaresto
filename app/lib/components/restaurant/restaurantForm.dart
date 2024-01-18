import 'dart:convert';
import 'package:app/views/adminView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/app_config.dart';
import '../../models/restaurantModel.dart';

class RestaurantForm extends StatefulWidget {
  final int? idRestaurant;

  RestaurantForm({this.idRestaurant});

  @override
  _RestaurantFormState createState() => _RestaurantFormState();

  static Widget buildImageTextField(
      TextEditingController controller, int index, Function(int) onDelete) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            onDelete(index);
          },
        ),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: 'URL de l\'image'),
          ),
        ),
      ],
    );
  }
}

class _RestaurantFormState extends State<RestaurantForm> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeKitchenController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  List<TextEditingController> imageControllers = [TextEditingController()];
  List<Widget> imageFields = [];

  @override
  void initState() {
    super.initState();
    if (widget.idRestaurant != null) {
      getRestaurant().then((restaurant) {
        nameController.text = restaurant.nom ?? '';
        typeKitchenController.text = restaurant.typeCuisine ?? '';
        addressController.text = restaurant.adresse ?? '';
        noteController.text = restaurant.note?.toString() ?? '';

        imageControllers = restaurant.image
            ?.map((url) => TextEditingController(text: url))
            .toList() ?? [TextEditingController()];
        imageFields = imageControllers
            .asMap()
            .map((i, controller) => MapEntry(
          i,
          ImageField(
            index: i,
            imageControllers: imageControllers,
            onDelete: (int index) {
              _onDelete(index);
            },
          ),
        ))
            .values
            .toList();

        setState(() {});
      });
    }
  }

  Future<void> saveRestaurant(Restaurant restaurant) async {
    final apiUrl = Uri.parse('${AppConfig.apiBaseUrl}/Restaurants');

    try {
      final jsonData = restaurant.toJson();
      final jsonString = jsonEncode(jsonData);

      final response = await http.post(
        apiUrl,
        headers: {
          'X-Apikey': '${AppConfig.apiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonString,
      );

      if (response.statusCode == 201) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminView()),
        );

        print('Création du restaurant réussite');
      } else {
        print(jsonString);
        print('Erreur lors de l\'inscription: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de requête: $e');
    }
  }

  Future<Restaurant> getRestaurant() async {
    try {
      final String apiUrl =
          '${AppConfig.apiBaseUrl}/Restaurants/${widget.idRestaurant}';
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'X-Apikey': '${AppConfig.apiKey}',
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = json.decode(response.body);
        return Restaurant.fromJson(jsonData);
      } else {
        print('Erreur de requête API: ${response.statusCode}');
        throw Exception(
            'API request failed with status code ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur lors de la requête API: $e');
      throw Exception('Error during API request: $e');
    }
  }

  Future<void> updateRestaurant(BuildContext context, Restaurant restaurant) async {
    final apiUrl =
    Uri.parse('${AppConfig.apiBaseUrl}/Restaurants/${widget.idRestaurant}');

    try {
      final jsonString = jsonEncode(restaurant);

      final response = await http.put(
        apiUrl,
        headers: {
          'X-Apikey': '${AppConfig.apiKey}',
          'Content-Type': 'application/json',
        },
        body: jsonString,
      );

      if (response.statusCode == 200) {
        print('Mise à jour du restaurant réussite');

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AdminView()),
        );
      } else {
        print(jsonString);
        print('Erreur lors de la mise à jour du restaurant: ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur de requête: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                alignment: Alignment.topRight,
                padding: EdgeInsets.all(8.0),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Column(
                children: [
                  for (var field in imageFields) field,
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        int newIndex = imageControllers.length;
                        imageControllers.add(TextEditingController());
                        imageFields.add(ImageField(
                          index: newIndex,
                          imageControllers: imageControllers,
                          onDelete: (int index) {
                            _onDelete(index);
                          },
                        ));
                      });
                    },
                    child: Text('Ajouter une image'),
                  ),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Nom de l\'enseigne'),
                  ),
                  TextField(
                    controller: typeKitchenController,
                    decoration: InputDecoration(labelText: 'Type de cuisine'),
                  ),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(labelText: 'Ville'),
                  ),
                  TextField(
                    controller: noteController,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Note du restaurant'),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      Restaurant newRestaurant = Restaurant(
                        id: 0,
                        nom: nameController.text,
                        typeCuisine: typeKitchenController.text,
                        note: double.tryParse(noteController.text) ?? 0.0,
                        adresse: addressController.text,
                        image: imageControllers
                            .map((controller) => controller.text)
                            .where((url) => url.isNotEmpty) // Filter out empty URLs
                            .toList(),
                      );

                      if (widget.idRestaurant != null && widget.idRestaurant! > 0) {
                        updateRestaurant(context, newRestaurant);
                      } else {
                        saveRestaurant(newRestaurant);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.principalColor,
                      foregroundColor: AppConfig.fontWhiteColor,
                      padding: const EdgeInsetsDirectional.symmetric(
                          horizontal: 50.0, vertical: 25.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text(widget.idRestaurant != null && widget.idRestaurant! > 0 ? 'Modifier' : 'Créer'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onDelete(int index) {
    setState(() {
      if (index >= 0 && index < imageControllers.length) {
        imageControllers.removeAt(index);
        imageFields = []
            .asMap()
            .map((i, controller) => MapEntry(
          i,
          ImageField(
            index: i,
            imageControllers: imageControllers,
            onDelete: (int index) {
              _onDelete(index);
            },
          ),
        ))
            .values
            .toList();
      }
    });
  }
}

class ImageField extends StatelessWidget {
  final int index;
  final List<TextEditingController> imageControllers;
  final void Function(int)? onDelete;

  const ImageField({
    required this.index,
    required this.imageControllers,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RestaurantForm.buildImageTextField(
      imageControllers[index],
      index,
      onDelete!,
    );
  }
}
