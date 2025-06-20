import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/local_db/hive_data_source.dart';
import 'auth_provider.dart';

// State notifier for managing access token
class AccessTokenNotifier extends StateNotifier<String> {
  final HiveDataSource _hiveDataSource;

  AccessTokenNotifier(this._hiveDataSource) : super('') {
    loadTokenFromStorage();
  }

  // Load token from local storage on initialization
  Future<void> loadTokenFromStorage() async {
    try {
      final token = await _hiveDataSource.getAccessToken();
      if (token != null && token.isNotEmpty) {
        state = token;
      }
    } catch (e) {
      print('Error loading token from storage: $e');
    }
  }



  // Set new token and persist to storage
  Future<void> setToken(String token) async {
    try {
      state = token;
      await _hiveDataSource.updateAccessToken(token);
    } catch (e) {
      print('Error storing token: $e');
    }
  }

  // Clear token from memory and storage
  Future<void> clearToken() async {
    try {
      state = '';
      await _hiveDataSource.clearAccessToken();
    } catch (e) {
      print('Error clearing token: $e');
    }
  }

  // Check if token exists and is not empty
  bool get hasToken => state.isNotEmpty;

  // Get current token
  String get token => state;
}

// Provider for accessing token state
final accessTokenProvider = StateNotifierProvider<AccessTokenNotifier, String>(
      (ref) => AccessTokenNotifier(ref.read(hiveDataSourceProvider)),
);

// Convenience provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final token = ref.watch(accessTokenProvider);
  return token.isNotEmpty;
});