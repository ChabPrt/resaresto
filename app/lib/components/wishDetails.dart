import 'package:flutter/material.dart';
import '../models/wishModel.dart';
import 'WishCard.dart';

class WishDetail extends StatelessWidget {
  final String date;
  final List<Wish> propositions;

  WishDetail({required this.date, required this.propositions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20.0),
        Text(
          date,
          style: TextStyle(
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
          ),
        ),
        ...propositions.map((proposition) => WishCard(wish: proposition)),
      ],
    );
  }
}
