import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../dashboard/dashboard.dart';
import '../ctrl/access_token_provider.dart';
import '../view/login_screen.dart';

class AppInitializerScreen extends ConsumerStatefulWidget {
  const AppInitializerScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AppInitializerScreen> createState() => _AppInitializerScreenState();
}

class _AppInitializerScreenState extends ConsumerState<AppInitializerScreen> {
  @override
  void initState() {
    super.initState();
    // Start the initialization process
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Add a small delay to show the splash screen
    await Future.delayed(const Duration(seconds: 2));

    // Wait for the token to be loaded by accessing the notifier
    final accessTokenNotifier = ref.read(accessTokenProvider.notifier);
    await accessTokenNotifier.loadTokenFromStorage(); // Ensure token is loaded

    if (mounted) {
      _checkAuthAndNavigate();
    }
  }

  void _checkAuthAndNavigate() {
    // Get the authentication status
    final isAuthenticated = ref.read(isAuthenticatedProvider);

    if (isAuthenticated) {
      // User is authenticated, navigate to dashboard
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    } else {
      // User is not authenticated, navigate to login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            // Image.asset("name"),
            // SizedBox(height: 24),
            // App Name
            Text(
              'Sewa Mitra',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            // Tagline
            Text(
              'Your Service Partner',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            SizedBox(height: 48),
            // Loading Indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            // Loading Text
            Text(
              'Initializing...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}