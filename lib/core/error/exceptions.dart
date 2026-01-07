/// Custom exceptions for the application
///
/// These exceptions are used in the Data layer and caught/converted
/// to Failures before crossing into the Domain layer.
/// This maintains the Clean Architecture principle that the Domain
/// layer should not depend on external libraries or framework specifics.

/// Base exception for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppException({required this.message, this.code, this.stackTrace});

  @override
  String toString() => 'AppException(code: $code, message: $message)';
}

/// Server/API related exceptions
class ServerException extends AppException {
  final int? statusCode;
  final Map<String, dynamic>? response;

  const ServerException({
    required super.message,
    super.code,
    super.stackTrace,
    this.statusCode,
    this.response,
  });

  factory ServerException.fromStatusCode(int statusCode, [String? message]) {
    final defaultMessage = _getMessageForStatusCode(statusCode);
    return ServerException(
      message: message ?? defaultMessage,
      statusCode: statusCode,
      code: 'SERVER_ERROR_$statusCode',
    );
  }

  static String _getMessageForStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Not found';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      case 503:
        return 'Service unavailable';
      default:
        return 'Server error occurred';
    }
  }
}

/// Cache/Local storage exceptions
class CacheException extends AppException {
  const CacheException({required super.message, super.code, super.stackTrace});

  factory CacheException.notFound(String key) {
    return CacheException(
      message: 'Cache entry not found for key: $key',
      code: 'CACHE_NOT_FOUND',
    );
  }

  factory CacheException.writeError(String key) {
    return CacheException(
      message: 'Failed to write cache for key: $key',
      code: 'CACHE_WRITE_ERROR',
    );
  }
}

/// Network/Connectivity exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.stackTrace,
  });

  factory NetworkException.noConnection() {
    return const NetworkException(
      message: 'No internet connection available',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Connection timed out',
      code: 'TIMEOUT',
    );
  }
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    super.code,
    super.stackTrace,
    this.fieldErrors,
  });
}

/// Not found exceptions
class NotFoundException extends AppException {
  final String resourceType;
  final String? resourceId;

  const NotFoundException({
    required super.message,
    required this.resourceType,
    this.resourceId,
    super.code,
    super.stackTrace,
  });

  factory NotFoundException.forResource(String resourceType, String id) {
    return NotFoundException(
      message: '$resourceType with id $id not found',
      resourceType: resourceType,
      resourceId: id,
      code: 'NOT_FOUND',
    );
  }
}
