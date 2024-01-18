import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/reviewModel.dart';

class ReviewHomeCard extends StatelessWidget {
  final Review review;
  final String restaurantName;
  final String userName;

  ReviewHomeCard({required this.review, required this.restaurantName, required this.userName});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 10.0),
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              restaurantName,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: 200.0,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                    ),
                    items: review.images?.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Image.network(image, fit: BoxFit.cover);
                        },
                      );
                    }).toList() ??
                        [],
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '" ${review.commantaire} "',
                        style: TextStyle(fontSize: 25.0),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        '${userName}',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: List.generate(
                          5,
                              (index) {
                            if (index < review.note.round()) {
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
