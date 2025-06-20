import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewamitraapp/feature/auth/view/new_password_screen.dart';
import '../../../config/services/remote_services/errors/failure.dart';
import '../services/auth_services.dart';

class OtpController {
  final otpFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final WidgetRef ref;

  OtpController(this.ref);


  Future<bool> handleOtp(BuildContext context) async {
    if (!otpFormKey.currentState!.validate()) return false;

    final credentials = {'email': emailController.text.trim()};

    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendOtp(data: credentials);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('OTP sent, please check your email!'), backgroundColor: Colors.green),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NewPasswordScreen()),
      );

      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP failed: ${e is Failure ? e.message : e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
  }

  void dispose() {
    emailController.dispose();
  }
}
