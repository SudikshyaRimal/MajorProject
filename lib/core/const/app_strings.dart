

// Sample service data - replace with your actual data source
import 'package:flutter/material.dart';

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
  ),
  Service(
    id: '2',
    name: 'Electrical Repair',
    category: 'Electrical',
    rating: 4.6,
    price: 'Rs. 600/hour',
    image: Icons.electrical_services,
    description: 'Licensed electricians for safe repairs',
    isAvailable: true,
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
  ),
  Service(
    id: '5',
    name: 'Appliance Repair',
    category: 'Repair',
    rating: 4.5,
    price: 'Rs. 400/hour',
    image: Icons.build,
    description: 'Fix all your home appliances',
    isAvailable: true,
  ),
  Service(
    id: '6',
    name: 'Gardening Service',
    category: 'Gardening',
    rating: 4.4,
    price: 'Rs. 300/hour',
    image: Icons.grass,
    description: 'Maintain your garden beautifully',
    isAvailable: true,
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
