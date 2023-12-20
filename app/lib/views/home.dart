import 'package:flutter/material.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Restaurant Finder'),
        ),
        body: RestaurantForm(),
      ),
    );
  }
}

class RestaurantForm extends StatefulWidget {
  @override
  _RestaurantFormState createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _restaurantNameController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background_image.jpg"), // Remplacez par le chemin de votre image
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Une envie de restaurant ?",
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.0),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _locationController,
                  decoration: InputDecoration(
                    hintText: "Où ?",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.location_on,
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: TextFormField(
                  controller: _restaurantNameController,
                  decoration: InputDecoration(
                    hintText: "Nom du restaurant...",
                    hintStyle: TextStyle(color: Colors.white),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(width: 10.0),
              ElevatedButton(
                onPressed: () {
                  // Action à effectuer lors de la validation
                  // Par exemple, afficher les informations saisies
                  print("Lieu: ${_locationController.text}");
                  print("Nom du restaurant: ${_restaurantNameController.text}");
                },
                child: Text("Valider"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
