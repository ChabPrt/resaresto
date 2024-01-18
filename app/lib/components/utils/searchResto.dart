import 'package:app/views/bookingView.dart';
import 'package:flutter/material.dart';
import 'package:app/config/app_config.dart';
import 'package:intl/intl.dart';

class SearchResto extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RestaurantForm(),
    );
  }
}

class RestaurantForm extends StatefulWidget {
  @override
  _RestaurantFormState createState() => _RestaurantFormState();
}

class _RestaurantFormState extends State<RestaurantForm> {
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _restaurantNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  bool isFormValid = false;

  @override
  Widget build(BuildContext context) {
    isFormValid = _locationController.text.isNotEmpty && _dateController.text.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 120.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          image: const DecorationImage(
            image: AssetImage("assets/img/background_search.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Une envie de restaurant ?",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 25.0),
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppConfig.principalColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            color: AppConfig.principalColor,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: TextFormField(
                              controller: _locationController,
                              decoration: const InputDecoration(
                                hintText: "À proximité de …",
                                hintStyle: TextStyle(
                                  color: AppConfig.fontLightGreyColor,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: AppConfig.fontBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _locationController.clear();
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: AppConfig.principalColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppConfig.principalColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: AppConfig.principalColor,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                hintText: "Aujourd'hui, demain, dans une semaine…",
                                hintStyle: TextStyle(
                                  color: AppConfig.fontLightGreyColor,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: AppConfig.fontBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                              onTap: () => _selectDate(context),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _dateController.clear();
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: AppConfig.principalColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppConfig.principalColor),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppConfig.principalColor,
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: TextFormField(
                              controller: _restaurantNameController,
                              decoration: const InputDecoration(
                                hintText: "Cuisine, nom de restaurant…",
                                hintStyle: TextStyle(
                                  color: AppConfig.fontLightGreyColor,
                                  fontWeight: FontWeight.normal,
                                ),
                                border: InputBorder.none,
                              ),
                              style: const TextStyle(
                                color: AppConfig.fontBlackColor,
                                fontWeight: FontWeight.w500,
                              ),
                              onChanged: (_) => setState(() {}),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              _restaurantNameController.clear();
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: AppConfig.principalColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: isFormValid && isDateValid(_dateController.text)
                        ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingView(
                            address: _locationController.text,
                            date: _dateController.text,
                          ),
                        ),
                      );
                    }
                        : null, // Désactiver le bouton si le formulaire n'est pas valide ou si la date n'est pas valide
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConfig.principalColor,
                      foregroundColor: AppConfig.fontWhiteColor,
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 50.0, vertical: 25.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text("Recherche"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }

  bool isDateValid(String date) {
    final RegExp dateRegExp = RegExp(r'^\d{2}/\d{2}/\d{4}$');
    return dateRegExp.hasMatch(date);
  }
}
