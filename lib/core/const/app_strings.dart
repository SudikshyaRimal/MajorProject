

// Sample service data - replace with your actual data source
import 'package:flutter/material.dart';

import '../../feature/home/model/service.dart';
import '../../feature/service_provider/model/job.dart';

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
  // 'Gardening'
];



List<Job> upcomingJobs = [
  Job(
    id: 'J001',
    category: 'Cleaning',
    subCategory: 'House Cleaning',
    customerName: 'John Doe',
    address: '123 Main St, Thamel, Kathmandu',
    scheduledDate: DateTime(2025, 7, 15),
    scheduledTime: '10:00 AM',
    duration: '3 hours',
    payment: 'Rs. 2,500',
    description: 'Deep cleaning of 3-bedroom house including kitchen and bathrooms',
    customerPhone: '+977-9841234567',
    specialInstructions: 'Please bring your own cleaning supplies',
    status: JobStatus.pending,
  ),
  Job(
    id: 'J002',
    category: 'Plumbing',
    subCategory: 'Pipe Repair',
    customerName: 'Jane Smith',
    address: '456 Oak Ave, Patan, Lalitpur',
    scheduledDate: DateTime(2025, 7, 16),
    scheduledTime: '2:00 PM',
    duration: '2 hours',
    payment: 'Rs. 1,800',
    description: 'Fix leaking pipe in kitchen sink',
    customerPhone: '+977-9851234567',
    specialInstructions: 'Kitchen entrance is from the back door',
    status: JobStatus.pending,
  ),
  Job(
    id: 'J003',
    category: 'Electrical',
    subCategory: 'Lighting Setup',
    customerName: 'Ram Sharma',
    address: '789 Buddha St, Bhaktapur',
    scheduledDate: DateTime(2025, 7, 17),
    scheduledTime: '11:00 AM',
    duration: '4 hours',
    payment: 'Rs. 3,200',
    description: 'Install LED lights in living room and bedroom',
    customerPhone: '+977-9861234567',
    specialInstructions: 'Customer will provide the LED fixtures',
    status: JobStatus.pending,
  ),
  Job(
    id: 'J004',
    category: 'Painting',
    subCategory: 'Interior Painting',
    customerName: 'Sita Patel',
    address: '321 River Rd, Baneshwor, Kathmandu',
    scheduledDate: DateTime(2025, 7, 14),
    scheduledTime: '9:00 AM',
    duration: '6 hours',
    payment: 'Rs. 4,500',
    description: 'Paint bedroom walls with customer-provided paint',
    customerPhone: '+977-9871234567',
    specialInstructions: 'Please cover furniture with plastic sheets',
    status: JobStatus.accepted,
  ),
];