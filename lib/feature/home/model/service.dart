
// Service Model
import 'package:flutter/material.dart';

class Service {
  final String id;
  final String name;
  final String category;
  final double rating;
  final String price;
  final IconData image;
  final String description;
  final bool isAvailable;

  Service({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.price,
    required this.image,
    required this.description,
    required this.isAvailable,
  });
}