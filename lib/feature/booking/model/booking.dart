
import 'package:flutter/material.dart';

class Booking {
  final String id;
  final Service service;
  final DateTime date;
  final String totalPrice;
  String status;
  final String? notes;

  Booking({
    required this.id,
    required this.service,
    required this.date,
    required this.totalPrice,
    required this.status,
    this.notes,
  });
}



class Service {
  final String name;
  final String category;
  final IconData image;
  final String price;

  Service({
    required this.name,
    required this.category,
    required this.image,
    required this.price,
  });
}