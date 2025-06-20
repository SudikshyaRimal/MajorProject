import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../config/local_db/hive_data_source.dart';

final hiveDataSourceProvider = Provider<HiveDataSource>((ref) {
  return HiveDataSource();
  // Reuse singleton instance
});


class AccessTokenNotifier extends StateNotifier<String> {
  final HiveDataSource _hiveDataSource;

  AccessTokenNotifier(this._hiveDataSource) : super('') {
    initializeToken();
  }


  Future<void> initializeToken() async {
    try {
      final token = await _hiveDataSource.getAccessToken();
      state = token;
      print('Initial Token: $state'); // Debug print
    } catch (e) {
      print('Error initializing token: $e'); // Error logging
      state = '';
    }
  }

  Future<void> updateToken(String token) async {
    try {
      await _hiveDataSource.updateAccessToken(token);
      state = token;
      print('Token updated: $state'); // Debug print
    } catch (e) {
      print('Error updating token: $e'); // Log error for debugging
      state = ''; // Reset state on failure
      rethrow; // Propagate error to caller (e.g., NetworkInterceptor)
    }
  }

  Future<void> clearToken() async {
    try {
      await _hiveDataSource.clearAccessToken();
      state = '';
      print('Token cleared'); // Debug print
    } catch (e) {
      print('Error clearing token: $e'); // Log error
      state = ''; // Ensure state is cleared even on error
    }
  }
}

// Provide the instance of AccessTokenNotifier using dependency injection
final accessTokenProvider = StateNotifierProvider<AccessTokenNotifier, String>((ref) {
  return AccessTokenNotifier(ref.read(hiveDataSourceProvider));
});

