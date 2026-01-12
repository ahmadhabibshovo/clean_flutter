/// App-wide failure types (Clean Architecture)
///
/// The domain/presentation layers should depend on these value objects
/// instead of catching exceptions directly.
abstract class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required super.message, super.code, this.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure({required super.message, super.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({required super.message, super.code});
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure({
    required super.message,
    super.code,
    this.fieldErrors,
  });
}

class NotFoundFailure extends Failure {
  final String resourceType;
  final String? resourceId;

  const NotFoundFailure({
    required super.message,
    required this.resourceType,
    this.resourceId,
    super.code,
  });
}

class UnexpectedFailure extends Failure {
  final Object? originalError;

  const UnexpectedFailure({
    required super.message,
    this.originalError,
    super.code,
  });

  factory UnexpectedFailure.fromException(Object error) {
    return UnexpectedFailure(message: error.toString(), originalError: error);
  }
}
