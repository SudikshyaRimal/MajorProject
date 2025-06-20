import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/auth/model/otp_response_model.dart';
import 'package:sewa_mitra/feature/auth/model/success_model.dart';
import '../../../config/services/remote_services/api_endpoints.dart';
import '../../../config/services/remote_services/errors/failure.dart';
import '../../../config/services/remote_services/http_service.dart';
import '../../../config/services/remote_services/http_service_provider.dart';
import '../ctrl/access_token_provider.dart';
import '../ctrl/auth_provider.dart';

// Service class for handling authentication-related API calls
class AuthServices {
  // HTTP service for making network requests
  final HttpService _httpService;
  final Ref ref;


  // Constructor initializes the HTTP service via provider
  AuthServices(this._httpService, this.ref);

  // Sends login request to the server with provided credentials
  Future<SuccessModel> postLoginCred({required Map<String, dynamic> data}) async {
    // Make POST request to login endpoint
    final result = await _httpService.post(ApiEndPoints.userLogin, data: data);

    return result.fold(
      // Handle failure case by throwing the failure
          (failure) => throw failure,
      // Handle success case by parsing response
          (response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Extract token from response headers
          await _handleTokenFromHeaders(response);

          // Parse and return success response
          return SuccessModel.fromJson(response.data);
        }
        // Throw error for unexpected response status
        throw Failure(message: 'Unexpected response format');
      },
    );
  }

  // Extract and store token from response headers
  Future<void> _handleTokenFromHeaders(Response response) async {
    try {
      // Get the set-cookie header
      final cookies = response.headers['set-cookie'];

      if (cookies != null && cookies.isNotEmpty) {
        // Find the token cookie
        for (final cookie in cookies) {
          if (cookie.startsWith('token=')) {
            // Extract token value (remove 'token=' and everything after ';')
            final tokenValue = cookie
                .split('token=')[1]
                .split(';')[0];

            // Store token using your access token provider
            ref.read(accessTokenProvider.notifier).setToken(tokenValue);

            // Also store in Hive for persistence
            final hiveDataSource = ref.read(hiveDataSourceProvider);
            await hiveDataSource.updateAccessToken(tokenValue);

            print('Token extracted and stored: ${tokenValue.substring(0, 20)}...');
            break;
          }
        }
      }
    } catch (e) {
      print('Error extracting token from headers: $e');
      // Don't throw here as login might still be considered successful
    }
  }

  // Sends registration request to the server with provided data
  Future<SuccessModel> postRegister({required Map<String, dynamic> data}) async {
    // Make POST request to registration endpoint
    final result = await _httpService.post(ApiEndPoints.userRegistration, data: data);
    return result.fold(
      // Handle failure case by throwing the failure
          (failure) => throw failure,
      // Handle success case by parsing response
          (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Parse and return success response
          return SuccessModel.fromJson(response.data);
        }
        // Throw error for unexpected response status
        throw Failure(message: 'Unexpected response format');
      },
    );
  }

  Future<OtpResponseModel> sendOtp({required Map<String, dynamic> data}) async {
    // Make POST request to registration endpoint
    final result = await _httpService.post(ApiEndPoints.userOtp, data: data);
    return result.fold(
      // Handle failure case by throwing the failure
          (failure) => throw failure,
      // Handle success case by parsing response
          (response) {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Parse and return success response
          return OtpResponseModel.fromJson(response.data);
        }
        // Throw error for unexpected response status
        throw Failure(message: 'Unexpected response format');
      },
    );
  }


// Alternative method if you want to handle token extraction separately
  String? extractTokenFromSetCookie(List<String>? cookies) {
    if (cookies == null || cookies.isEmpty) return null;

    for (final cookie in cookies) {
      if (cookie.startsWith('token=')) {
        return cookie.split('token=')[1].split(';')[0];
      }
    }
    return null;
  }


}



// Provider for AuthServices, initialized with HttpService from provider
final authServiceProvider = Provider<AuthServices>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return AuthServices(httpService, ref);
});