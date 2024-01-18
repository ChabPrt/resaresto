import 'package:app/components/wishForm.dart';
import 'package:app/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../models/userModel.dart';

class UserCard extends StatefulWidget {
  final User user;
  final bool? isSelected;
  final void Function(int userId)? onCardSelected;

  UserCard({
    required this.user,
    this.isSelected,
    this.onCardSelected,
  });

  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onCardSelected?.call(widget.user.id ?? 0);
        setState(() {
          _isSelected = !_isSelected;
        });
      },
      child: _buildCard(context),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: _isSelected
            ? BorderSide(color: Colors.green, width: 2.0)
            : BorderSide.none,
      ),
      elevation: 4,
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 3,
                padding: const EdgeInsets.all(15.0),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _buildImageProvider(widget.user.image ?? ""),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.user.nom,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.user.prenom,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.user.mail,
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  ImageProvider<Object> _buildImageProvider(String image) {
    if (image.startsWith('http')) {
      return NetworkImage(image);
    } else {
      return AssetImage("assets/img/user_default_icon.jpg");
    }
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
                Text('Aucune image du user'),
              ],
            ),
        ],
      ),
    );
  }
}
