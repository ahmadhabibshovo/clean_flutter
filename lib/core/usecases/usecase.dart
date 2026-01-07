import '../error/failures.dart';
import '../types/result.dart';

/// Base class for all use cases in the application
///
/// This enforces a consistent contract for all use cases following
/// the Command pattern. Each use case represents a single business
/// operation and follows the Single Responsibility Principle.
///
/// Type Parameters:
/// - [Type]: The return type of the use case
/// - [Params]: The parameter type (use NoParams if no parameters needed)
///
/// Usage:
/// ```dart
/// class GetUserUseCase extends UseCase<User, GetUserParams> {
///   final UserRepository repository;
///
///   GetUserUseCase(this.repository);
///
///   @override
///   Future<Result<User>> call(GetUserParams params) async {
///     return repository.getUser(params.id);
///   }
/// }
/// ```
abstract class UseCase<Type, Params> {
  /// Execute the use case with the given parameters
  ///
  /// Returns a [Result] that either contains the successful [Type]
  /// or a [Failure] describing what went wrong.
  Future<Result<Type>> call(Params params);
}

/// Use case base class for operations that don't return data
///
/// Useful for commands that perform actions without returning
/// meaningful data (e.g., delete operations, log events).
abstract class UseCaseVoid<Params> extends UseCase<void, Params> {}

/// Use case base class for stream-based operations
///
/// Useful for operations that return continuous data streams
/// (e.g., real-time updates, websocket data).
abstract class StreamUseCase<Type, Params> {
  /// Execute the use case and return a stream of results
  Stream<Result<Type>> call(Params params);
}

/// Marker class for use cases that don't require parameters
///
/// Use this instead of void or dynamic for type safety:
/// ```dart
/// class GetAllUsersUseCase extends UseCase<List<User>, NoParams> {
///   @override
///   Future<Result<List<User>>> call(NoParams params) async {
///     return repository.getAllUsers();
///   }
/// }
///
/// // Call with:
/// final result = await getAllUsersUseCase(NoParams());
/// ```
class NoParams {
  const NoParams();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NoParams && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;
}

/// Base class for use case parameters
///
/// Provides a standard interface for parameters with validation.
/// Extend this class to create type-safe parameter objects.
///
/// Usage:
/// ```dart
/// class CreateUserParams extends Params {
///   final String name;
///   final String email;
///
///   const CreateUserParams({required this.name, required this.email});
///
///   @override
///   List<Object?> get props => [name, email];
///
///   @override
///   ValidationResult validate() {
///     if (name.isEmpty) {
///       return ValidationResult.invalid('Name cannot be empty');
///     }
///     if (!email.contains('@')) {
///       return ValidationResult.invalid('Invalid email format');
///     }
///     return ValidationResult.valid();
///   }
/// }
/// ```
abstract class Params {
  const Params();

  /// List of properties for equality comparison
  List<Object?> get props;

  /// Validate the parameters
  ///
  /// Override this to add parameter validation logic.
  /// Returns [ValidationResult] indicating if params are valid.
  ValidationResult validate() => ValidationResult.valid();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Params &&
          runtimeType == other.runtimeType &&
          _listEquals(props, other.props);

  @override
  int get hashCode => Object.hashAll(props);

  bool _listEquals(List<Object?> a, List<Object?> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

/// Result of parameter validation
class ValidationResult {
  final bool isValid;
  final String? errorMessage;
  final Map<String, String>? fieldErrors;

  const ValidationResult._({
    required this.isValid,
    this.errorMessage,
    this.fieldErrors,
  });

  factory ValidationResult.valid() => const ValidationResult._(isValid: true);

  factory ValidationResult.invalid(
    String message, [
    Map<String, String>? fields,
  ]) => ValidationResult._(
    isValid: false,
    errorMessage: message,
    fieldErrors: fields,
  );

  /// Convert to a ValidationFailure if invalid
  ValidationFailure? toFailure() {
    if (isValid) return null;
    return ValidationFailure(
      message: errorMessage ?? 'Validation failed',
      fieldErrors: fieldErrors,
    );
  }
}
