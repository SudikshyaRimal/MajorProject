import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/auth/ctrl/otp_controller.dart';
import '../../../core/cust_text_form_field.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  bool _isLoading = false;
  bool _otpVerified = false;

  void _handleOtp() async {
    setState(() => _isLoading = true);

    final controller = OtpController(ref);
    final success = await controller.handleOtp(context);
    if (success) {
      setState(() {
        _otpVerified = true;
      });
    }

    setState(() => _isLoading = false);
  }

  void _resendOTP() {
    // Simulate resend or call actual resend logic from controller
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent'), backgroundColor: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = OtpController(ref);

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
                    key: controller.otpFormKey,
                    child: CustomTextFormField(
                      hintText: 'Enter 6-digit OTP',
                      prefixIcon: Icons.vpn_key,
                      controller: controller.emailController,
                      keyboardType: TextInputType.number,
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
