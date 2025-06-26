
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sewamitraapp/config/local_db/hive_setup.dart';
import 'package:sewamitraapp/feature/auth/view/login_screen.dart';
import 'package:sewamitraapp/feature/auth/view/register_screen.dart';
import 'package:sewamitraapp/feature/dashboard/dashboard.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await HiveSetup.initHive;
  runApp(const ProviderScope(child: MyApp()));
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final box = await Hive.openLazyBox('authBox');
    final token = await box.get('token');
    print('token: $token');
    if (token != null && token.isNotEmpty) {
      // Token found, navigate to Dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );
    } else {
      // No token, navigate to Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Simple loading indicator while checking
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: LoginScreen(),
      home: 
      SplashScreen()
     // LoginScreen()
      //RegistrationScreen()
      //DashboardScreen(),
    );
  }
}
