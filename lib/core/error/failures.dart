/// Base class for all failures in the application
///
/// Following the "Failure" pattern from Clean Architecture, this provides
/// a type-safe way to handle errors throughout the application without
/// exposing implementation details or using exceptions for control flow.
///
/// Benefits:
/// - Type safety: Compiler catches unhandled failure cases
/// - Separation of concerns: Domain errors vs technical errors
/// - Testability: Easy to mock and test failure scenarios
/// - Immutability: All failures are immutable value objects
abstract class Failure {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const Failure({required this.message, this.code, this.stackTrace});

  @override
  String toString() => 'Failure(code: $code, message: $message)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message &&
          code == other.code;

  @override
  int get hashCode => message.hashCode ^ code.hashCode;
}

/// Server failures - for API/backend related errors
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    required super.message,
    super.code,
    super.stackTrace,
    this.statusCode,
  });
}

/// Cache/Local storage failures
class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code, super.stackTrace});
}

/// Network failures - connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code, super.stackTrace});
}

/// Validation failures - business rule violations
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    super.stackTrace,
    this.fieldErrors,
  });
}

/// Not found failures - resource doesn't exist
class NotFoundFailure extends Failure {
  final String resourceType;
  final String? resourceId;

  const NotFoundFailure({
    required super.message,
    required this.resourceType,
    this.resourceId,
    super.code,
    super.stackTrace,
  });
}

/// Permission/Authorization failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Unknown/Unexpected failures
class UnexpectedFailure extends Failure {
  final Object? originalError;

  const UnexpectedFailure({
    required super.message,
    super.code,
    super.stackTrace,
    this.originalError,
  });

  factory UnexpectedFailure.fromException(Object error, [StackTrace? trace]) {
    return UnexpectedFailure(
      message: error.toString(),
      originalError: error,
      stackTrace: trace,
    );
  }
}
