import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../feature/auth/ctrl/access_token_provider.dart';
import '../../../../feature/auth/ctrl/auth_provider.dart';
import '../../../local_db/hive_data_source.dart';
import '../api_endpoints.dart';

class NetworkInterceptor implements Interceptor {
  final Ref ref;
  final HiveDataSource hive;
  bool _isRefreshing = false;

  NetworkInterceptor(this.ref) : hive = ref.read(hiveDataSourceProvider);

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final isLoginRequest = err.requestOptions.path.contains(ApiEndPoints.userLogin);
    final statusCode = err.response?.statusCode;

    log('❌ Error [${statusCode ?? 'NO STATUS'}]: ${err.requestOptions.uri}');

    if (statusCode == 401 && !isLoginRequest) {
      if (_isRefreshing) {
        log('Already refreshing, rejecting request');
        return handler.reject(err);
      }

      _isRefreshing = true;
      try {
        log('Token refresh succeeded, proceeding to retry');
        try {
          final response = await _retryRequest(err.requestOptions);
          log('Retry succeeded with status: ${response.statusCode} ${response.data}');
          handler.resolve(response); // Directly resolve without return
        } catch (retryError) {
          log('Retry failed after successful refresh: $retryError');
          handler.reject(err); // Reject without navigating to login
        }
      } catch (refreshError) {
        log('Refresh failed: $refreshError');
        handler.reject(err);
      } finally {
        _isRefreshing = false;
        log('Refresh process completed');
      }
    } else {
      log('Not a 401 or login request, passing error through');
      handler.next(err);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _attachAuthHeader(options);
    log('✅ Request [${options.method}] ${options.uri}');
    log('✅ Headers: ${options.headers}');
    handler.next(options);
  }

  void _attachAuthHeader(RequestOptions options) {
    final requiresAuth = options.extra['requiresAuth'] ?? true;
    if (requiresAuth) {
      final token = ref.read(accessTokenProvider);
      log('🔑 Using token: ${token.isEmpty ? 'No token' : 'Token exists'}');
      if (token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
  }


  Future<Response<dynamic>> _retryRequest(RequestOptions options) async {
    final updatedToken = ref.read(accessTokenProvider);
    log('🔄 Retrying request: ${options.method} ${options.path}');
    log('🔄 Retry headers: ${{
      ...options.headers,
      'Authorization': 'Bearer $updatedToken',
    }}');
    log('🔄 Retry data: ${options.data}');
    log('🔄 Retry query: ${options.queryParameters}');
    try {
      final dio = Dio(BaseOptions(baseUrl: ApiEndPoints.baseUrl));
      final response = await dio.request<dynamic>(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: Options(
          method: options.method,
          headers: {
            ...options.headers,
            'Authorization': 'Bearer $updatedToken',
          },
        ),
      );
      log('🔄 Retry response: ${response.statusCode} ${response.data}');
      return response;
    } catch (e) {
      log('🔄 Retry failed: $e');
      rethrow;
    }
  }




  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ Response [${response.statusCode}] ${response.requestOptions.uri}');
    handler.next(response);
  }
}
