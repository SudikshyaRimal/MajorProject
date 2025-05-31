
import 'package:flutter/material.dart';
import 'package:sewa_mitra/feature/auth/view/register_screen.dart';

import '../../../core/cust_text_form_field.dart';
import '../../../core/form_validators.dart';
import '../../dashboard/dashboard.dart';
import 'forgot_password_screen.dart';

import 'package:flutter/material.dart';
import 'package:sewa_mitra/feature/auth/view/register_screen.dart';

import '../../../core/cust_text_form_field.dart';
import '../../../core/form_validators.dart';
import 'forgot_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:sewa_mitra/feature/auth/view/register_screen.dart';

import '../../../core/cust_text_form_field.dart';
import '../../../core/form_validators.dart';
import 'forgot_password_screen.dart';

// Define the LoginScreen as a StatefulWidget since it
// needs to manage state (e.g., loading state, form inputs)
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// The state class for LoginScreen, where the logic and UI are defined
class _LoginScreenState extends State<LoginScreen> {
  // Form key to manage form validation
  final _formKey = GlobalKey<FormState>();
  // Controllers to capture user input for email and password fields
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // Boolean to track loading state during login (e.g., for showing a loading indicator)
  bool _isLoading = false;

  // Dispose controllers to free up resources when the widget is removed
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Function to handle login logic
  void _handleLogin() async {
    // Check if the form is valid (based on validators)
    if (_formKey.currentState!.validate()) {
      // Set loading state to true to show loading indicator
      setState(() {
        _isLoading = true;
      });

      // Simulate an API call with a 2-second delay (replace with actual API call in production)
      await Future.delayed(const Duration(seconds: 2));

      // After the "API call", set loading state back to false
      setState(() {
        _isLoading = false;
      });

      // Check if the widget is still mounted before updating the UI
      if (mounted) {
        // Show a success message using a SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login successful!'),
            backgroundColor: Colors.green,
          ),
        );


        // Navigate to the home screen after successful login (commented out for now)
        // Navigator.pushReplacementNamed(context, '/home');

        Navigator.push(context, MaterialPageRoute(builder: (builder) => DashboardScreen()));
      }
    }
  }

  // Function to navigate to the Forgot Password screen
  void _handleForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPasswordScreen(),
      ),
    );
  }

  // Function to navigate to the Registration screen
  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegistrationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Set a light grey background for the screen
      body: SafeArea(
        // Ensure content is within the safe area (avoids notches, status bar, etc.)
        child: Center(
          child: SingleChildScrollView(
            // Allow scrolling if content overflows (e.g., on smaller screens)
            padding: const EdgeInsets.all(24.0), // Add padding around the content
            child: Form(
              key: _formKey, // Attach the form key for validation
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch children to fill width
                children: [
                  const SizedBox(height: 40), // Add spacing at the top

                  // Logo/Title Section
                  Column(
                    children: [
                      // Display a lock icon as a placeholder for the logo
                      Icon(
                        Icons.lock_person_rounded,
                        size: 60,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(height: 16), // Space between icon and text
                      // Main title text
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8), // Space between title and subtitle
                      // Subtitle text
                      Text(
                        'Sign in to your account',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40), // Space between title section and form fields

                  // Email Input Field
                  CustomTextFormField(
                    hintText: 'Email Address', // Placeholder text
                    prefixIcon: Icons.email_outlined, // Icon on the left side of the field
                    controller: _emailController, // Controller to capture input
                    validator: FormValidators.validateEmail, // Validator for email format
                    keyboardType: TextInputType.emailAddress, // Optimized keyboard for email input
                  ),

                  // Password Input Field
                  CustomTextFormField(
                    hintText: 'Password', // Placeholder text
                    prefixIcon: Icons.lock_outline, // Icon on the left side of the field
                    controller: _passwordController, // Controller to capture input
                    validator: (value) => FormValidators.validateRequired(
                      value,
                      fieldName: 'Password', // Validator to ensure the field isn't empty
                    ),
                    obscureText: true, // Hide the password input
                    showPasswordToggle: true, // Show a toggle to reveal/hide the password
                  ),

                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight, // Align the button to the right
                    child: TextButton(
                      onPressed: _handleForgotPassword, // Navigate to Forgot Password screen
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24), // Space before the login button

                  // Login Button
                  SizedBox(
                    height: 52, // Set a fixed height for the button
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleLogin, // Disable button while loading
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600], // Button background color
                        foregroundColor: Colors.white, // Button text/icon color
                        elevation: 2, // Add a slight shadow for depth
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                      ),
                      child: _isLoading
                          ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Show a loading indicator while the "API call" is in progress
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12), // Space between indicator and text
                          Text(
                            'Signing in...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                          : const Text(
                        'Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32), // Space after the login button

                  // Divider with "OR" in the middle
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[300])), // Left divider line
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[300])), // Right divider line
                    ],
                  ),

                  const SizedBox(height: 32), // Space after the divider

                  // Register Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: _navigateToRegister, // Navigate to Registration screen
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
