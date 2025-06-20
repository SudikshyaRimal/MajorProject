import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sewa_mitra/feature/home/model/category.dart';
import '../../../config/services/remote_services/api_endpoints.dart';
import '../../../config/services/remote_services/errors/failure.dart';
import '../../../config/services/remote_services/http_service.dart';
import '../../../config/services/remote_services/http_service_provider.dart';
import '../model/provider_model.dart';

// Service class for handling authentication-related API calls
class HomeServices {
  // HTTP service for making network requests
  final HttpService _httpService;
  final Ref ref;


  // Constructor initializes the HTTP service via provider
  HomeServices(this._httpService, this.ref);

  // Sends login request to the server with provided credentials
  Future<Category> getAllCategories() async {
    // Make POST request to login endpoint
    final result = await _httpService.get(ApiEndPoints.getAllCategory);

    return result.fold(
      // Handle failure case by throwing the failure
          (failure) => throw failure,
      // Handle success case by parsing response
          (response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Extract token from response headers
          // Parse and return success response
          return Category.fromJson(response.data);
        }
        // Throw error for unexpected response status
        throw Failure(message: 'Unexpected response format');
      },
    );
  }

 Future<ProviderModel> getAgentsByCategories({required String category}) async {
    // Make POST request to login endpoint
    final result = await _httpService.get("${ApiEndPoints.getWorkers}?category=$category");

    return result.fold(
      // Handle failure case by throwing the failure
          (failure) => throw failure,
      // Handle success case by parsing response
          (response) async {
        if (response.statusCode == 200 || response.statusCode == 201) {
          // Extract token from response headers
          // Parse and return success response
          return ProviderModel.fromJson(response.data);
        }
        // Throw error for unexpected response status
        throw Failure(message: 'Unexpected response format');
      },
    );
  }




}



// Provider for AuthServices, initialized with HttpService from provider
final authServiceProvider = Provider<HomeServices>((ref) {
  final httpService = ref.watch(httpServiceProvider);
  return HomeServices(httpService, ref);
});