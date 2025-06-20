import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewamitraapp/feature/auth/model/otp_response_model.dart';
import 'package:sewamitraapp/feature/auth/model/success_model.dart';

import '../../../config/services/remote_services/api_endpoints.dart';
import '../../../config/services/remote_services/errors/failure.dart';
import '../../../config/services/remote_services/http_service.dart';
import '../../../config/services/remote_services/http_service_provider.dart';

// Service class for handling authentication-related API calls
class AuthServices {
  // HTTP service for making network requests
  final HttpService _httpService;

  // Constructor initializes the HTTP service via provider
  AuthServices(this._httpService);

  // Sends login request to the server with provided credentials
  Future<SuccessModel> postLoginCred({required Map<String, dynamic> data}) async {
    // Make POST request to login endpoint
    final result = await _httpService.post(ApiEndPoints.userLogin, data: data);
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

//category list 
  Future<OtpResponseModel>userCategory({required Map<String, dynamic> data}) async {
    // Make POST request to registration endpoint
    final result = await _httpService.post(ApiEndPoints.userCategory, data: data);
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
}



// Provider for AuthServices, initialized with HttpService from provider
final authServiceProvider = Provider<AuthServices>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return AuthServices(httpService);
});