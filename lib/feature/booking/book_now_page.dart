import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sewamitraapp/config/services/remote_services/api_endpoints.dart';
import 'package:sewamitraapp/feature/booking/booking_confirmation_page.dart';
import '../dashboard/history_page.dart';
import '../home/model/service.dart';


class BookNowPage extends StatefulWidget {
  final Service? initialService; // Optional pre-selected service

  const BookNowPage({super.key, this.initialService});

  @override
  State<BookNowPage> createState() => _BookNowPageState();
}

class _BookNowPageState extends State<BookNowPage> {
  // Sample service list (in a real app, fetch from a data source)


  Future<bool> createBooking({
  required String token,
  required String fullname,
  required String providerId,
  required String date,     // e.g., '2024-09-10'
  required String time,     // e.g., '14:00'
  required String location,
}) async {
  print('inside create booking');
  final url = Uri.parse('${ApiEndPoints.baseUrl}booking/book'); // Replace with your actual endpoint
String token ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY4NTUwMGViMjgyOWFmN2FjZTI3YjdkNSIsImlhdCI6MTc1MDQxNTY0NCwiZXhwIjoxNzUxMDIwNDQ0fQ.wziSP2L3ls8ZZ_aw2Ir49E151fzT0DwxZZA6C4iMCwo';
  final body = {
    "fullname": fullname,
    "providerId": providerId,
    "date": date,
    "time": time,
    "location": location,
  };

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  try {
    final response = await http.post(
      url,
      headers: headers,
      body: json.encode(body),
    );
print('booking res${response.body}');
    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      print('Booking successful: ${responseData['booking']['_id']}');
      return true;
    } else {
      print('Booking failed: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error creating booking: $e');
    return false;
  }
}
  final List<Service> _services = [
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
  ];

  Service? _selectedService;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialService; // Pre-select service if provided
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _confirmBooking() {
    createBooking(token: 'token', fullname: _selectedService!.name, providerId: '68551f5e823307363b2a19e2', date: _selectedDate.toString(), time: _selectedTime.toString(), location: 'Kathmandu');

    if (_selectedService == null || _selectedDate == null || _selectedTime == null) {

createBooking(token: 'token', fullname: '_selectedService!.name', providerId: '68551f5e823307363b2a19e2', date: _selectedDate.toString(), time: _selectedTime.toString(), location: 'location');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Create a Booking object
    final booking = Booking(
      id: 'b${DateTime.now().millisecondsSinceEpoch}',
      service: _selectedService!,
      date: DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      ),
      status: 'Upcoming',
      totalPrice: _selectedService!.price,
    );

    // Navigate to BookingConfirmationPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingConfirmationPage(
          booking: booking,
          notes: _notesController.text,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Book Now'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service Selection
            const Text(
              'Select Service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Service>(
              value: _selectedService,
              decoration: InputDecoration(
                labelText: 'Service',
                labelStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.build, color: Colors.blue[600]),
              ),
              items: _services
                  .where((service) => service.isAvailable)
                  .map((service) => DropdownMenuItem<Service>(
                value: service,
                child: Text(service.name),
              ))
                  .toList(),
              onChanged: (Service? newValue) {
                setState(() {
                  _selectedService = newValue;
                });
              },
            ),
            const SizedBox(height: 16),
            // Date Selection
            const Text(
              'Select Date',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _pickDate(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Text(
                      _selectedDate == null
                          ? 'Select a date'
                          : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedDate == null ? Colors.grey[600] : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Time Selection
            const Text(
              'Select Time',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _pickTime(context),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.access_time, color: Colors.blue[600]),
                    const SizedBox(width: 8),
                    Text(
                      _selectedTime == null
                          ? 'Select a time'
                          : _selectedTime!.format(context),
                      style: TextStyle(
                        fontSize: 14,
                        color: _selectedTime == null ? Colors.grey[600] : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Additional Notes
            const Text(
              'Additional Notes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: 'Any specific requirements?',
                labelStyle: TextStyle(color: Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: Icon(Icons.note, color: Colors.blue[600]),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            // Booking Summary
            if (_selectedService != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Booking Summary',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Service:',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          _selectedService!.name,
                          style: const TextStyle(fontSize: 14, color: Colors.black87),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Price:',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          _selectedService!.price,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),
            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _confirmBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}