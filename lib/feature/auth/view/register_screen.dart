import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/auth/ctrl/register_ctrl.dart';
import 'package:sewa_mitra/feature/auth/view/login_screen.dart';

import '../../../core/cust_text_form_field.dart';
import '../../../core/form_validators.dart';

// Registration Screen with Form Validation
class RegistrationScreen extends ConsumerWidget {


  bool _isLoading = false;
  String _selectedUserType = '';



  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final controller = RegisterController(ref);


    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Form(
              key: controller.registerFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo/Title Section
                  Column(
                    children: [
                      Icon(
                        Icons.person_add_rounded,
                        size: 60,
                        color: Colors.blue[600],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join Sewa Mitra today',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Form Fields using CustomTextFormField
                  CustomTextFormField(
                    hintText: 'First Name',
                    prefixIcon: Icons.person_outline,
                    controller: controller.firstNameController,
                    validator: FormValidators.validateName,
                    textCapitalization: TextCapitalization.words,
                  ),

                  CustomTextFormField(
                    hintText: 'Last Name',
                    prefixIcon: Icons.person_outline,
                    controller: controller.lastNameController,
                    validator: FormValidators.validateName,
                    textCapitalization: TextCapitalization.words,
                  ),

                  CustomTextFormField(
                    hintText: 'Email Address',
                    prefixIcon: Icons.email_outlined,
                    controller: controller.emailController,
                    validator: FormValidators.validateEmail,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  CustomTextFormField(
                    hintText: 'Password',
                    prefixIcon: Icons.lock_outline,
                    controller: controller.passwordController,
                    validator: FormValidators.validatePassword,
                    obscureText: true,
                    showPasswordToggle: true,
                  ),

                  CustomTextFormField(
                    hintText: 'Address',
                    prefixIcon: Icons.location_on_outlined,
                    controller: controller.addressController,
                    validator: (value) => FormValidators.validateRequired(value, fieldName: 'Address'),
                    maxLines: 2,
                    textCapitalization: TextCapitalization.words,
                  ),

                  const SizedBox(height: 32),

                  // Registration Type Selection
                  Text(
                    'Register as:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // User Registration Button
                  _buildRegisterButton(
                    text: 'Service User',
                    icon: Icons.person,
                    isPrimary: true,
                    isLoading: _isLoading && _selectedUserType == 'Service User',
                    onPressed: () => controller.handleRegistration(context),
                  ),

                  const SizedBox(height: 12),

                  // Provider Registration Button
                  _buildRegisterButton(
                    text: 'Service Provider',
                    icon: Icons.work,
                    isPrimary: false,
                    isLoading: _isLoading && _selectedUserType == 'Service Provider',
                    onPressed: () => controller.handleRegistration(context),
                  ),

                  const SizedBox(height: 24),

                  // Login redirect
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to login
                          Navigator.push(context, MaterialPageRoute(builder: (builder)=> LoginScreen()));
                        },
                        child: Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton({
    required String text,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return SizedBox(
      height: 52,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        )
            : Icon(icon, size: 20),
        label: Text(
          isLoading ? 'Processing...' : text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary ? Colors.blue[600] : Colors.white,
          foregroundColor: isPrimary ? Colors.white : Colors.blue[600],
          elevation: isPrimary ? 2 : 0,
          side: isPrimary ? null : BorderSide(color: Colors.blue[600]!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}