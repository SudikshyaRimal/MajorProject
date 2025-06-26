import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:sewamitraapp/config/local_db/hive_keys.dart';
import 'package:sewamitraapp/config/services/remote_services/api_endpoints.dart';
import 'package:sewamitraapp/feature/auth/view/login_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
   String name = 'John Doe';

   String email = 'john.doe@example.com';

   String phone = '+977-987-654-3210';

   String twitter = 'https://x.com/johndoe';

   String linkedin = 'https://linkedin.com/in/johndoe';

   String github = 'https://github.com/johndoe';
bool isLoading = true;
  Future<void> _launchUrl(BuildContext context, String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch $url'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }
  
 Future<void> _loadProfile() async {
    final data = await fetchUserProfile();
    if (data != null) {
      setState(() {
        name = '${data['firstname']} ${data['lastname']}' ?? '';
        email = data['email'] ?? '';
        phone = data['phone'] ?? '';
        twitter = data['twitter'] ?? '';
        linkedin = data['linkedin'] ?? '';
        github = data['github'] ?? '';
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // Optionally show error
    }
  }
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 16, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
        ),
      ),
    );
  }

  Widget _buildInfoTile(String label, String value, {IconData? icon, VoidCallback? onTap}) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        leading: Icon(icon ?? Icons.info_outline, color: Colors.blue[600], size: 24),
        trailing: onTap != null
            ? Icon(Icons.open_in_new, color: Colors.blue[600], size: 20)
            : null,
        onTap: onTap,
      ),
    );
  }

Future<Map<String, dynamic>?> fetchUserProfile() async {
  final box = await Hive.openLazyBox(HIVE_TOKEN_BOX);
  final token = await box.get('token');

  if (token == null) return null;

  final response = await http.get(
    Uri.parse('${ApiEndPoints.baseUrl}${ApiEndPoints.getProfile}'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );
    print('fetchUserProfile response: ${response.body}');

  if (response.statusCode == 200) {
    print('fetchUserProfile response: ${response.body}');
    return json.decode(response.body) as Map<String, dynamic>;
  } else {
    return null; // Or handle errors
  }
}
  @override
  void initState() {
    super.initState();
    _loadProfile();
  }
  @override
  Widget build(BuildContext context) {

     if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Picture
            Center(
              child: Container(
                width: 120,
                height: 120,
                margin: const EdgeInsets.only(top: 20, bottom: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.blue[400]!, Colors.blue[700]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  size: 70,
                  color: Colors.white,
                ),
              ),
            ),
            Center(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Personal Information
            _buildSectionHeader('Personal Information'),
            _buildInfoTile('Full Name', name, icon: Icons.person),
            _buildInfoTile('Email', email, icon: Icons.email),
            _buildInfoTile('Phone Number', phone, icon: Icons.phone),
            // Social Links
            _buildSectionHeader('Social Links'),
            _buildInfoTile(
              'Twitter/X',
              twitter,
              icon: Icons.link,
              onTap: () => _launchUrl(context, twitter),
            ),
            _buildInfoTile(
              'LinkedIn',
              linkedin,
              icon: Icons.link,
              onTap: () => _launchUrl(context, linkedin),
            ),
            _buildInfoTile(
              'GitHub',
              github,
              icon: Icons.link,
              onTap: () => _launchUrl(context, github),
            ),
            const SizedBox(height: 32),
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: ()async {
                 await logout();
                  Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Logged out successfully'),
                      backgroundColor: Colors.blue[600],
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
                child: const Text(
                  'Log Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> clearToken() async {
  final box = await Hive.openLazyBox(HIVE_TOKEN_BOX);
  await box.delete('token');
}

Future<void> logout() async {
  await clearToken();
  
  // Any other logout cleanup like resetting app state, navigating to login screen
}
}