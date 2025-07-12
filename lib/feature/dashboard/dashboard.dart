import 'package:flutter/material.dart';
import 'package:sewa_mitra/feature/agent/agents_form_page.dart';
import 'package:sewa_mitra/feature/service_provider/profile_creation_page.dart';
import 'about_us.dart';
import 'history_page.dart';
import 'home_page.dart';
import 'profile_page.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // List of pages corresponding to each navigation item
  final List<Widget> _pages = [
    const HomePage(),
     HistoryPage(),
    ProfileCreationPage(),
     // AgentsFormPage(),
    // const ProfilePage(),
    const AboutUsPage(),
  ];

  // Handle navigation item selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[600],
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Agent'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About Us'),

        ],
      ),
    );
  }
}


