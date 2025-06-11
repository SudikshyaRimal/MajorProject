import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/auth/services/auth_services.dart';
import '../../../config/services/remote_services/errors/failure.dart';
import '../../../config/services/remote_services/http_service_provider.dart';
import '../view/login_screen.dart';
import 'auth_provider.dart';

// Controller for handling login screen logic and state
class LoginController {
  // Form key for validating the login form
  final formKey = GlobalKey<FormState>();

  // Text controllers for email and password input fields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Riverpod Ref for accessing providers
  final WidgetRef ref;

  // Tracks loading state during login process
  bool isLoading = false;

  // Constructor initializes with Riverpod Ref
  LoginController(this.ref);

  // Handles the login process, including validation and API call
  Future<bool> handleLogin(BuildContext context) async {
    // Validate form inputs
    if (!formKey.currentState!.validate()) return false;

    // Set loading state to true and update UI
    isLoading = true;
    setState(context);

    // Prepare credentials for login API
    final credentials = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {
      // Access AuthServices via provider and call login API
      final authService = ref.read(authServiceProvider);
      await authService.postLoginCred(data: credentials);
      return true; // Return true on successful login
    } catch (e) {
      // Show error message in a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e is Failure ? e.message : e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false; // Return false on login failure
    } finally {
      // Reset loading state and update UI
      isLoading = false;
      setState(context);
    }
  }

  // Triggers UI update by calling setState on the LoginScreen
  void setState(BuildContext context) {
    if (context.mounted) {
      (context as State<LoginScreen>).setState(() {});
    }
  }

  // Cleans up resources by disposing text controllers
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}