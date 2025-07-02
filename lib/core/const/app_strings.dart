

// Sample service data - replace with your actual data source
import 'package:flutter/material.dart';

import '../../feature/booking/model/sub_category.dart';
import '../../feature/home/model/service.dart';
final List<Service> services = [
  Service(
    id: '1',
    name: 'Professional Plumbing',
    category: 'Plumbing',
    rating: 4.8,
    price: 'Rs. 500/hour',
    image: Icons.plumbing,
    description: 'Expert plumbing services for all your needs',
    isAvailable: true,
    subCategories: [
      SubCategory(
        id: '1a',
        name: 'Pipe Repair',
        price: 'Rs. 600/hour',
        description: 'Fixing leaks and broken pipes',
      ),
      SubCategory(
        id: '1b',
        name: 'Drain Cleaning',
        price: 'Rs. 550/hour',
        description: 'Clearing clogged drains',
      ),
    ],
  ),
  Service(
    id: '2',
    name: 'Painter',
    category: 'Painter',
    rating: 4.6,
    price: 'Rs. 600/hour',
    image: Icons.electrical_services,
    description: 'Licensed painters',
    isAvailable: true,
    subCategories: [
      SubCategory(
        id: '2a',
        name: 'Interior Painting',
        price: 'Rs. 650/hour',
        description: 'Painting interior walls',
      ),
      SubCategory(
        id: '2b',
        name: 'Exterior Painting',
        price: 'Rs. 700/hour',
        description: 'Painting exterior surfaces',
      ),
    ],
  ),
  Service(
    id: '3',
    name: 'AC Maintenance',
    category: 'HVAC',
    rating: 4.7,
    price: 'Rs. 800/visit',
    image: Icons.ac_unit,
    description: 'Complete AC servicing and repairs',
    isAvailable: false,
    subCategories: [],
  ),
  Service(
    id: '4',
    name: 'House Cleaning',
    category: 'Cleaning',
    rating: 4.9,
    price: 'Rs. 1200/day',
    image: Icons.cleaning_services,
    description: 'Professional house cleaning services',
    isAvailable: true,
    subCategories: [
      SubCategory(
        id: '4a',
        name: 'Deep Cleaning',
        price: 'Rs. 1500/day',
        description: 'Thorough cleaning of entire house',
      ),
      SubCategory(
        id: '4b',
        name: 'Regular Cleaning',
        price: 'Rs. 1200/day',
        description: 'Standard cleaning services',
      ),
    ],
  ),
];


final List<String> categories = [
  'All',
  'Plumbing',
  'Electrical',
  'HVAC',
  'Cleaning',
  'Repair',
  'Gardening'
];
