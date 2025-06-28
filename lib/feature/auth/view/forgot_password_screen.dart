
// Forgot Password Screen
import 'package:flutter/material.dart';
import 'package:sewa_mitra/feature/auth/view/otp_verification_screen.dart';

import '../../../core/cust_text_form_field.dart';
import '../../../core/form_validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/auth/ctrl/otp_controller.dart';
import 'package:sewa_mitra/feature/auth/view/otp_verification_screen.dart';

import '../../../core/cust_text_form_field.dart';
import '../../../core/form_validators.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleResetPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final controller = OtpController(ref);
      // Update controller's emailController with the email from ForgotPasswordScreen
      controller.emailController.text = _emailController.text.trim();

      try {
        final success = await controller.handleOtp(context);
        if (success) {
          setState(() {
            _emailSent = true;
          });
          // Navigate to OtpVerificationScreen instead of NewPasswordScreen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const OtpVerificationScreen()),
          );
        }
      } catch (e) {
        // Error handling is already done in handleOtp, no need to show another SnackBar
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _resendEmail() async {
    setState(() {
      _isLoading = true;
    });

    final controller = OtpController(ref);
    controller.emailController.text = _emailController.text.trim();

    try {
      final success = await controller.handleOtp(context);
      if (success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reset email sent again!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      // Error handling is already done in handleOtp
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[700]),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Icon and Title
                Column(
                  children: [
                    Icon(
                      _emailSent ? Icons.mark_email_read : Icons.lock_reset,
                      size: 60,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _emailSent ? 'Check Your Email' : 'Forgot Password?',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _emailSent
                          ? 'We\'ve sent a password reset link to your email address'
                          : 'Enter your email address and we\'ll send you a link to reset your password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                if (!_emailSent) ...[
                  // Email Form
                  Form(
                    key: _formKey,
                    child: CustomTextFormField(
                      hintText: 'Email Address',
                      prefixIcon: Icons.email_outlined,
                      controller: _emailController,
                      validator: FormValidators.validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Send Reset Email Button
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? _handleResetPassword : _handleResetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Sending...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      )
                          : const Text(
                        'Send Reset Link',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,

                        ),
                      ),

                    ),

                  ),
                ] else ...[
                  // Success State
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Colors.green[600],
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Reset email sent to:',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _emailController.text,
                          style: TextStyle(
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Resend Email Button
                  SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _isLoading ? null : _resendEmail,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.blue[600]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isLoading
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Sending...',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue[600],
                            ),
                          ),
                        ],
                      )
                          : Text(
                        'Resend Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[600],
                        ),
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 32),

                // Back to Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remember your password? ',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.new,
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
    );
  }
}