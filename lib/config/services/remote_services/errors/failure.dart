import 'package:dio/dio.dart';

/// Custom object for handling failures and exceptions
class Failure {
  final String message;
  final int? statusCode;
  final Map<String, List<String>>? fieldErrors;
  final int? throttleSeconds; // New field for throttling wait time

  Failure({
    required this.message,
    this.statusCode,
    this.fieldErrors,
    this.throttleSeconds,
  });

  factory Failure.fromException(DioException e) {
    try {
      // Handle connection errors without response
      if (e.response == null) {
        return Failure(
          message: 'No internet connection',
          statusCode: e.error?.toString().contains('SocketException') ?? false
              ? 503
              : null,
        );
      }

      final statusCode = e.response?.statusCode;
      final responseData = e.response?.data;

      // Handle 429 (Too Many Requests)
      if (statusCode == 429) {
        String message = 'Request was throttled. Please try again later.';
        int? throttleSeconds;
        if (responseData is Map<String, dynamic> && responseData['detail'] != null) {
          final detail = responseData['detail'] as String;
          message = detail;
          final match = RegExp(r'(\d+) seconds').firstMatch(detail);
          if (match != null) {
            throttleSeconds = int.tryParse(match.group(1) ?? '');
          }
        }
        return Failure(
          message: message,
          statusCode: statusCode,
          throttleSeconds: throttleSeconds,
        );
      }

      // Handle server errors (5xx)
      if (statusCode != null && statusCode >= 500 && statusCode < 600) {
        return Failure(
          message: 'Our server went down, please try again in a while',
          statusCode: statusCode,
        );
      }

      // Handle 403 specifically
      if (statusCode == 403) {
        String errorMessage = 'Forbidden: You lack permission to perform this action';
        if (responseData is Map<String, dynamic> && responseData['detail'] != null) {
          errorMessage = responseData['detail'] as String;
        } else if (responseData != null && responseData['error'] != null) {
          errorMessage = responseData['error'] as String;
        } else if (responseData != null) {
          errorMessage += ' - $responseData';
        }
        return Failure(
          message: errorMessage,
          statusCode: statusCode,
        );
      }

      // Handle 404 specifically
      if (statusCode == 404) {
        String errorMessage = 'Resource not found';
        if (responseData is Map<String, dynamic> && responseData['detail'] != null) {
          errorMessage = responseData['detail'] as String; // e.g., "No User matches the given query."
        } else if (responseData != null) {
          errorMessage += ' - $responseData';
        }
        return Failure(
          message: errorMessage,
          statusCode: statusCode,
        );
      }

      // Parse validation errors from response
      if (e.response?.data is Map<String, dynamic>) {
        final responseData = e.response!.data as Map<String, dynamic>;
        final fieldErrors = _parseFieldErrors(responseData);
        if (fieldErrors.isNotEmpty) {
          return Failure(
            message: 'Validation failed',
            statusCode: statusCode,
            fieldErrors: fieldErrors,
          );
        }
      }

      // Fallback to generic error handling with response data
      String message = e.message ?? 'Unknown error occurred';
      if (responseData != null) {
        message += ' - $responseData';
      }
      return Failure(
        message: message,
        statusCode: statusCode,
      );
    } catch (_) {
      return Failure(
        message: 'Unknown error occurred',
        statusCode: e.response?.statusCode,
      );
    }
  }

  static Map<String, List<String>> _parseFieldErrors(Map<String, dynamic> response) {
    final fieldErrors = <String, List<String>>{};
    response.forEach((key, value) {
      if (value is List) {
        fieldErrors[key] = value.map((e) => e.toString()).toList();
      }
    });
    return fieldErrors;
  }

  @override
  String toString() => 'Failure(message: $message, statusCode: $statusCode, throttleSeconds: $throttleSeconds)';
}