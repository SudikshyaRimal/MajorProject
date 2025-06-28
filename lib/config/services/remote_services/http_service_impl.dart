import 'package:dio/dio.dart';
import 'package:either_dart/either.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_endpoints.dart';
import 'errors/failure.dart';
import 'http_service.dart';
import 'interceptors/api_interceptor.dart';

// Implementation of the HttpService interface for making HTTP requests
class HttpServiceImpl implements HttpService {
  // Dio instance for handling HTTP requests
  late final Dio dio;

  // Riverpod Ref for accessing providers
  final Ref ref;

  // Constructor initializes Dio with base options and network interceptor
  HttpServiceImpl(this.ref) {
    dio = Dio(baseOptions);
    dio.interceptors.add(NetworkInterceptor(ref));
  }

  // Base URL for API requests
  @override
  String get baseUrl => ApiEndPoints.baseUrl;

  // Provider for generating dynamic headers
  final dynamicHeadersProvider = Provider<Map<String, String>>((ref) {
    return {
      'accept': 'application/json',
      'content-type': 'application/json',
    };
  });

  // Dynamic headers with user location information
  Map<String, String> get dynamicHeaders => ref.read(dynamicHeadersProvider);

  // Base options for Dio configuration
  BaseOptions get baseOptions => BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 40),
    receiveTimeout: const Duration(seconds: 10),
  );

  // Creates Dio options with headers and authentication settings
  Options _createOptions({bool? requiresAuth, String contentType = 'application/json'}) {
    final headers = Map<String, String>.from(dynamicHeaders);
    headers['Content-Type'] = contentType;
    return Options(
      headers: headers,
      extra: {'requiresAuth': requiresAuth},
    );
  }

  // Makes a GET request to the specified endpoint
  @override
  Future<Either<Failure, Response<dynamic>>> get(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        String? customBaseUrl,
        CancelToken? cancelToken,
        bool? requiresAuth = false,
      }) async {
    try {
      // Perform GET request with configured options
      final Response<dynamic> response = await dio.get(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _createOptions(requiresAuth: requiresAuth),
      );
      return Right(response);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      return Left(Failure.fromException(e));
    } catch (e) {
      // Handle generic errors
      return Left(Failure(message: e.toString()));
    }
  }

  // Makes a POST request to the specified endpoint
  @override
  Future<Either<Failure, Response>> post(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        FormData? formData,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        bool? requiresAuth = false,
        String? contentType,
        Map<String, dynamic>? data,
      }) async {
    try {
      // Perform POST request with configured options
      final Response<dynamic> response = await dio.post(
        endpoint,
        data: formData ?? data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        options: _createOptions(
          requiresAuth: requiresAuth,
          contentType: formData != null ? 'multipart/form-data' : 'application/json',
        ),
      );
      return Right(response);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      return Left(Failure.fromException(e));
    } catch (e) {
      // Handle generic errors
      return Left(Failure(message: e.toString()));
    }
  }

  // Makes a DELETE request to the specified endpoint
  @override
  Future<Either<Failure, Response<dynamic>>> delete(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        bool? requiresAuth,
      }) async {
    try {
      // Perform DELETE request with configured options
      final Response<dynamic> response = await dio.delete(
        endpoint,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: _createOptions(requiresAuth: requiresAuth),
      );
      return Right(response);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      return Left(Failure.fromException(e));
    } catch (e) {
      // Handle generic errors
      return Left(Failure(message: e.toString()));
    }
  }

  // Makes a PATCH request to the specified endpoint
  @override
  Future<Either<Failure, Response>> patch(
      String endpoint, {
        Map<String, dynamic>? queryParameters,
        Map<String, dynamic>? data,
        FormData? formData,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        bool? requiresAuth = false,
        String? contentType,
      }) async {
    try {
      // Perform PATCH request with configured options
      final Response<dynamic> response = await dio.patch(
        endpoint,
        cancelToken: cancelToken,
        data: formData ?? data,
        queryParameters: queryParameters,
        options: _createOptions(
          requiresAuth: requiresAuth,
          contentType: formData != null ? 'multipart/form-data' : 'application/json',
        ),
      );
      return Right(response);
    } on DioException catch (e) {
      // Handle Dio-specific errors
      return Left(Failure.fromException(e));
    } catch (e) {
      // Handle generic errors
      return Left(Failure(message: e.toString()));
    }
  }
}