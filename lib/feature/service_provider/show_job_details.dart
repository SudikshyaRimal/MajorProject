import 'package:flutter/material.dart';
import 'model/job.dart';
import 'service_provider_dashboard.dart';

class ShowJobDetails {

  static void showJobDetails(Job job, BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: getCategoryColor(job.category).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        getCategoryIcon(job.category),
                        color: getCategoryColor(job.category),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.subCategory,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1A1A1A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            job.category,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Job Details Section
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDetailRow('Customer', job.customerName,
                                Icons.person, Colors.blue[700]!),
                            const Divider(height: 16),
                            _buildDetailRow('Phone', job.customerPhone, Icons.phone,
                                Colors.green[700]!),
                            const Divider(height: 16),
                            _buildDetailRow('Address', job.address,
                                Icons.location_on, Colors.red[700]!),
                            const Divider(height: 16),
                            _buildDetailRow('Date', formatDate(job.scheduledDate),
                                Icons.calendar_today, Colors.purple[700]!),
                            const Divider(height: 16),
                            _buildDetailRow('Time', job.scheduledTime,
                                Icons.access_time, Colors.orange[700]!),
                            const Divider(height: 16),
                            _buildDetailRow('Duration', job.duration, Icons.timer,
                                Colors.teal[700]!),
                            const Divider(height: 16),
                            _buildDetailRow('Payment', job.payment,
                                Icons.attach_money, Colors.amber[700]!),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Description Section
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A1A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        job.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),

                      // Special Instructions Section
                      if (job.specialInstructions.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Special Instructions',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.amber[200]!),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Text(
                            job.specialInstructions,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.amber[900],
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Updated _buildDetailRow method for consistent styling
  static Widget _buildDetailRow(String label, String value, IconData icon, Color iconColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

IconData getCategoryIcon(String category) {
  switch (category) {
    case 'Cleaning':
      return Icons.cleaning_services;
    case 'Plumbing':
      return Icons.plumbing;
    case 'Electrical':
      return Icons.electrical_services;
    case 'Painting':
      return Icons.format_paint;
    default:
      return Icons.work;
  }
}

Color getCategoryColor(String category) {
  switch (category) {
    case 'Cleaning':
      return Colors.blue[600]!;
    case 'Plumbing':
      return Colors.indigo[600]!;
    case 'Electrical':
      return Colors.amber[600]!;
    case 'Painting':
      return Colors.purple[600]!;
    default:
      return Colors.grey[600]!;
  }
}