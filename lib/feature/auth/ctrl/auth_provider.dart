// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import '../../../config/services/remote_services/http_service_provider.dart';
// import '../services/auth_services.dart';
//
// // UI state providers for password visibility
// final isPasswordVisibleProvider = StateProvider<bool>((ref) => false);
// final isConfirmPasswordVisibleProvider = StateProvider<bool>((ref) => false);
//
// // Provider for the AuthService
// final authServiceProvider = Provider<AuthServices>((ref) {
//   final httpService = ref.watch(httpServiceProvider);
//   return AuthServices(httpService);
// });
//
// // Provider for user login with credentials
// final userLogInProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, signInRequest) async {
//   final authService = ref.read(authServiceProvider);
//   await authService.postLoginCred(data: signInRequest);
// });
//
//
//
//
