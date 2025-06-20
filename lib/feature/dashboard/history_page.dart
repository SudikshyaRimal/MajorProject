import 'package:flutter/material.dart';
import '../home/model/service.dart';
import '../home/view/service_details_sheet.dart';

class HistoryPage extends StatelessWidget {
   HistoryPage({super.key});

  // Sample booking data (in a real app, this would come from a data source)
  final List<Booking> _bookings = [
    Booking(
      id: 'b1',
      service: Service(
        id: '1',
        name: 'Professional Plumbing',
        category: 'Plumbing',
        rating: 4.8,
        price: 'Rs. 500/hour',
        image: Icons.plumbing,
        description: 'Expert plumbing services for all your needs',
        isAvailable: true,
      ),
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Completed',
      totalPrice: 'Rs. 1000',
    ),
    Booking(
      id: 'b2',
      service: Service(
        id: '4',
        name: 'House Cleaning',
        category: 'Cleaning',
        rating: 4.9,
        price: 'Rs. 1200/day',
        image: Icons.cleaning_services,
        description: 'Professional house cleaning services',
        isAvailable: true,
      ),
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Completed',
      totalPrice: 'Rs. 1200',
    ),
    Booking(
      id: 'b3',
      service: Service(
        id: '3',
        name: 'AC Maintenance',
        category: 'HVAC',
        rating: 4.7,
        price: 'Rs. 800/visit',
        image: Icons.ac_unit,
        description: 'Complete AC servicing and repairs',
        isAvailable: false,
      ),
      date: DateTime.now().add(const Duration(days: 1)),
      status: 'Upcoming',
      totalPrice: 'Rs. 800',
    ),
  ];

  void _showServiceDetails(BuildContext context, Service service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => 
      Text('')
      //ServiceDetailsSheet(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Booking History'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _bookings.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_toggle_off,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 12),
            Text(
              'No Bookings Found',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Your booking history will appear here',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        itemCount: _bookings.length,
        itemBuilder: (context, index) {
          final booking = _bookings[index];
          return BookingCard(
            booking: booking,
            onTap: () => _showServiceDetails(context, booking.service),
          );
        },
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback onTap;

  const BookingCard({
    super.key,
    required this.booking,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    booking.service.image,
                    color: Colors.blue[600],
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                // Booking Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              booking.service.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                            decoration: BoxDecoration(
                              color: booking.status == 'Completed'
                                  ? Colors.green[50]
                                  : Colors.blue[50],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              booking.status,
                              style: TextStyle(
                                color: booking.status == 'Completed'
                                    ? Colors.green[700]
                                    : Colors.blue[700],
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking.service.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(booking.date),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[700],
                            ),
                          ),
                          Text(
                            booking.totalPrice,
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

// Booking Model
class Booking {
  final String id;
  final Service service;
  final DateTime date;
  final String status;
  final String totalPrice;

  Booking({
    required this.id,
    required this.service,
    required this.date,
    required this.status,
    required this.totalPrice,
  });
}