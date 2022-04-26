import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

RatingBarIndicator buildRatingStars(double rating) {
  return RatingBarIndicator(
    rating: rating,
    itemBuilder: (context, index) =>
        const Icon(Icons.star, color: Colors.amber),
    itemCount: 5,
    itemSize: 15,
  );
}
