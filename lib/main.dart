import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/config/local_db/hive_setup.dart';
import 'package:sewa_mitra/feature/auth/view/forgot_password_screen.dart';
import 'package:sewa_mitra/feature/auth/view/login_screen.dart';
import 'package:sewa_mitra/feature/auth/view/new_password_screen.dart';
import 'package:sewa_mitra/feature/auth/view/register_screen.dart';
import 'package:sewa_mitra/feature/dashboard/dashboard.dart';

import 'feature/auth/services/app_initializer_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await HiveSetup.initHive;
  runApp(const ProviderScope(child: MyApp()));
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
      home: DashboardScreen(),
      // home: DashboardScreen(),
      // home: DashboardScreen(),
    );
  }
}
