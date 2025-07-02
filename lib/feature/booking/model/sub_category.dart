import 'package:flutter/material.dart';

class SubCategory {
  final String id;
  final String name;
  final String price; // Price specific to the sub-category
  final String description;

  SubCategory({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
  });
}

