import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/auth/ctrl/otp_controller.dart';
import '../../../core/cust_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/auth/ctrl/otp_controller.dart';
import 'package:sewa_mitra/feature/auth/view/new_password_screen.dart';
import '../../../core/cust_text_form_field.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  bool _isLoading = false;
  bool _otpVerified = false;
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  void _handleOtp() async {
    setState(() => _isLoading = true);

    // Simulate OTP verification or call actual API
    // For now, we'll simulate a successful verification
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _otpVerified = true;
      _isLoading = false;
    });

    // Navigate to NewPasswordScreen after successful verification
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const NewPasswordScreen()),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP verified successfully!'), backgroundColor: Colors.green),
    );
  }

  void _resendOTP() async {
    setState(() => _isLoading = true);

    final controller = OtpController(ref);
    // Assuming email is passed or stored; for now, we'll simulate
    try {
      final success = await controller.handleOtp(context);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('OTP resent'), backgroundColor: Colors.blue),
        );
      }
    } finally {
      setState(() => _isLoading = false);
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                Column(
                  children: [
                    Icon(
                      _otpVerified ? Icons.check_circle : Icons.verified_user,
                      size: 60,
                      color: Colors.blue[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _otpVerified ? 'OTP Verified' : 'Verify OTP',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _otpVerified
                          ? 'Your OTP has been verified successfully'
                          : 'Enter the 6-digit code sent to your email',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                if (!_otpVerified) ...[
                  Form(
                    key: GlobalKey<FormState>(),
                    child: CustomTextFormField(
                      hintText: 'Enter 6-digit OTP',
                      prefixIcon: Icons.vpn_key,
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the OTP';
                        }
                        if (value.length != 6 || !RegExp(r'^\d{6}$').hasMatch(value)) {
                          return 'Please enter a valid 6-digit OTP';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[600],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                          Text('Verifying...', style: TextStyle(fontWeight: FontWeight.w600)),
                        ],
                      )
                          : const Text('Verify OTP', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: TextButton(
                      onPressed: _isLoading ? null : _resendOTP,
                      child: Text('Resend OTP', style: TextStyle(color: Colors.blue[600])),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[600], size: 32),
                        const SizedBox(height: 12),
                        Text('OTP Verified', style: TextStyle(color: Colors.green[700])),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Didn\'t receive a code? ', style: TextStyle(color: Colors.grey[600])),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text('Try Again', style: TextStyle(color: Colors.blue[600])),
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
