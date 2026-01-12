import '../errors/failures.dart';

/// Simple Result type (Success/Failure) to avoid throwing exceptions.
sealed class Result<T> {
  const Result();

  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  });

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    return onSuccess(data);
  }
}

class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);

  @override
  R fold<R>({
    required R Function(Failure failure) onFailure,
    required R Function(T data) onSuccess,
  }) {
    return onFailure(failure);
  }
}

extension ResultFactories on Result {
  static Result<T> success<T>(T data) => Success<T>(data);
  static Result<T> failure<T>(Failure failure) => FailureResult<T>(failure);
}
