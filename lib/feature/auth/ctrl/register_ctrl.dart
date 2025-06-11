import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/auth/view/register_screen.dart';

import '../../../config/services/remote_services/errors/failure.dart';
import '../../dashboard/dashboard.dart';
import '../services/auth_services.dart';

class RegisterController {
  // Form key for validating the login form
  final registerFormKey = GlobalKey<FormState>();

  // Text controllers for email and password input fields
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();

  // Riverpod Ref for accessing providers
  final WidgetRef ref;

  // Tracks loading state during login process
  bool isLoading = false;

  // Constructor initializes with Riverpod Ref
  RegisterController(this.ref);

  // Handles the login process, including validation and API call
  Future<void> handleRegistration(BuildContext context) async {
    // Validate form inputs
    if (!registerFormKey.currentState!.validate())
      // return false;

    // Set loading state to true and update UI
    isLoading = true;
    setState(context);

    // Prepare credentials for login API
    final credentials = {
      'firstname':firstNameController.text.trim(),
      'lastname' :lastNameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
      'address': addressController.text.trim()
    };

    try {
      // Access AuthServices via provider and call login API
      final authService = ref.read(authServiceProvider);
      await authService.postRegister(data: credentials);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration successful!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardScreen()),
      );

    } catch (e) {
      // Show error message in a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration  failed: ${e is Failure ? e.message : e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      // return false; // Return false on login failure
    } finally {
      // Reset loading state and update UI
      // isLoading = false;
      setState(context);
    }
  }

  // Triggers UI update by calling setState on the LoginScreen
  void setState(BuildContext context) {
    if (context.mounted) {
      // (context as State<RegistrationScreen>).setState(() {});
    }
  }

  // Cleans up resources by disposing text controllers
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}