import '../error/failures.dart';

/// Result type for handling success and failure cases
///
/// This implements the "Either" pattern from functional programming,
/// providing a type-safe way to handle operations that can fail.
///
/// Benefits over try/catch:
/// - Explicit in function signature that operation can fail
/// - Forced handling of both success and failure cases
/// - No exception propagation through call stack
/// - Better composability with other operations
/// - Easier to test both success and failure paths
///
/// Usage:
/// ```dart
/// final result = await repository.getData();
/// result.fold(
///   onFailure: (failure) => showError(failure.message),
///   onSuccess: (data) => showData(data),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Create a success result
  factory Result.success(T data) = Success<T>;

  /// Create a failure result
  factory Result.failure(Failure failure) = ResultFailure<T>;

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is ResultFailure<T>;

  /// Get data if success, throws if failure
  T get dataOrThrow {
    return switch (this) {
      Success(:final data) => data,
      ResultFailure(:final failure) => throw failure,
    };
  }

  /// Get data if success, null if failure
  T? get dataOrNull {
    return switch (this) {
      Success(:final data) => data,
      ResultFailure() => null,
    };
  }

  /// Get failure if failure, null if success
  Failure? get failureOrNull {
    return switch (this) {
      Success() => null,
      ResultFailure(:final failure) => failure,
    };
  }

  /// Fold the result into a single value
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    return switch (this) {
      Success(:final data) => onSuccess(data),
      ResultFailure(:final failure) => onFailure(failure),
    };
  }

  /// Map success value to another type
  Result<R> map<R>(R Function(T data) mapper) {
    return switch (this) {
      Success(:final data) => Result.success(mapper(data)),
      ResultFailure(:final failure) => Result.failure(failure),
    };
  }

  /// FlatMap for chaining operations
  Result<R> flatMap<R>(Result<R> Function(T data) mapper) {
    return switch (this) {
      Success(:final data) => mapper(data),
      ResultFailure(:final failure) => Result.failure(failure),
    };
  }

  /// Execute side effect on success
  Result<T> onSuccess(void Function(T data) action) {
    if (this is Success<T>) {
      action((this as Success<T>).data);
    }
    return this;
  }

  /// Execute side effect on failure
  Result<T> onFailure(void Function(Failure failure) action) {
    if (this is ResultFailure<T>) {
      action((this as ResultFailure<T>).failure);
    }
    return this;
  }
}

/// Success case of Result
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;

  @override
  String toString() => 'Success($data)';
}

/// Failure case of Result - named ResultFailure to avoid conflict with Failure class
final class ResultFailure<T> extends Result<T> {
  final Failure failure;

  const ResultFailure(this.failure);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResultFailure<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'ResultFailure($failure)';
}
