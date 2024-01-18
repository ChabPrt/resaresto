import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/restaurantModel.dart';
import '../review/reviewsRestaurant.dart';
import '../wish/wishForm.dart';

class RestaurantCard extends StatefulWidget {
  final Restaurant restaurant;
  final String? date;
  final bool? isSelected;
  final bool isNotSelectable;
  final void Function(int restaurantId)? onCardSelected;

  RestaurantCard({
    required this.restaurant,
    this.date,
    this.isSelected,
    this.isNotSelectable = true,
    this.onCardSelected,
  });

  @override
  _RestaurantCardState createState() => _RestaurantCardState();
}

class _RestaurantCardState extends State<RestaurantCard> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.isNotSelectable
        ? GestureDetector(
      onTap: () {
        widget.onCardSelected?.call(widget.restaurant.id ?? 0);
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: _buildCard(context),
    )
        : _buildCard(context);
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: _isSelected ? BorderSide(color: Colors.green, width: 2.0) : BorderSide.none,
      ),
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 3,
                padding: const EdgeInsets.all(15.0),
                child: Carousel(images: widget.restaurant.image ?? []),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.restaurant.nom,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.restaurant.adresse,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: List.generate(
                          5,
                              (index) {
                            if (index < widget.restaurant.note.round()) {
                              return Icon(
                                Icons.star,
                                color: Colors.orange,
                              );
                            } else {
                              return Icon(
                                Icons.star,
                                color: Colors.grey,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (widget.date != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Les avis : ",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ReviewsRestaurantWrapper(idRestaurant: widget.restaurant.id ?? 0),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text(
                        "Faire une proposition de réservation ",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.all(8.0),
                        child: IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            _showWishFormDialog(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _showWishFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: WishForm(restaurant: widget.restaurant, date: widget.date ?? ""),
        );
      },
    );
  }
}

class Carousel extends StatelessWidget {
  final List<String> images;

  const Carousel({required this.images});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (images.length == 1)
            Image.network(
              images[0],
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
          if (images.length > 1)
            CarouselSlider(
              options: CarouselOptions(
                aspectRatio: 16 / 9,
                autoPlay: true,
                enlargeCenterPage: true,
              ),
              items: images.map((image) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              }).toList(),
            ),
          if (images.isEmpty)
            Column(
              children: [
                Icon(Icons.image, size: 50, color: Colors.grey),
                Text('Aucune image du restaurant'),
              ],
            ),
        ],
      ),
    );
  }
}
