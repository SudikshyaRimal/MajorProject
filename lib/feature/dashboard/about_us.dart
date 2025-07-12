// About Us Page
import 'package:flutter/material.dart';
import 'package:sewa_mitra/core/const/app_strings.dart';

import '../service_provider/job_history.dart';
import '../service_provider/service_provider_dashboard.dart';


class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('About Us'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card with Gradient
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[600]!, Colors.blue[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.home_work_outlined,
                    size: 60,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Trusted Home Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Quality • Reliability • Trust',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Company Description Card
            _buildInfoCard(
              'About Our Service',
              'We are a leading home service platform dedicated to connecting customers with trusted professionals. Our mission is to make home maintenance easy, reliable, and affordable. From plumbing to cleaning, our vetted service providers ensure top-quality work with a focus on customer satisfaction.',
              Icons.business_outlined,
            ),
            const SizedBox(height: 16),

            // Mission Card
            _buildInfoCard(
              'Our Mission',
              'To empower homeowners with seamless access to professional services, ensuring peace of mind and exceptional results every time.',
              Icons.flag_outlined,
            ),
            const SizedBox(height: 16),

            // Values Card
            _buildInfoCard(
              'Our Values',
              'Quality service, transparent pricing, professional expertise, and customer satisfaction are at the heart of everything we do.',
              Icons.favorite_outline,
            ),
            const SizedBox(height: 24),

            // Contact Information Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.contact_mail, color: Colors.blue[600], size: 24),
                      const SizedBox(width: 12),
                      Text(
                        'Contact Us',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildContactRow(Icons.email_outlined, 'support@servicesapp.com'),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.phone_outlined, '+977-123-456-7890'),
                  const SizedBox(height: 12),
                  _buildContactRow(Icons.location_on_outlined, 'Kathmandu, Nepal'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Navigation Cards
            _buildNavCard(
              context,
              'Service Provider Dashboard',
              Icons.dashboard,
              Colors.green[600]!,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  ServiceProviderDashboard()),
              ),
            ),
            const SizedBox(height: 16),
            _buildNavCard(
              context,
              'Job History',
              Icons.history,
              Colors.green[600]!,
                  () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  JobHistoryPage(jobs: upcomingJobs,)),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.blue[600], size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue[600], size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }


  Widget _buildNavCard(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.maxFinite,
        padding: const EdgeInsets.all(16),
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
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

}

