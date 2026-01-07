import '../../../../core/error/failures.dart';
import '../../../../core/types/result.dart';
import '../entities/counter_entity.dart';

/// Abstract repository for counter operations
///
/// This defines the contract for counter data operations following
/// Repository Pattern from Clean Architecture. The domain layer
/// depends on this abstraction, not concrete implementations.
///
/// All operations return [Result] to handle both success and failure
/// cases in a type-safe manner.
abstract class CounterRepository {
  /// Get the current counter value
  ///
  /// Returns [Result.success] with [CounterEntity] on success,
  /// or [Result.failure] with appropriate [Failure] on error.
  Future<Result<CounterEntity>> getCounter();

  /// Increment the counter by [amount]
  ///
  /// [amount] defaults to 1 if not specified.
  /// Respects the maximum value boundary defined in [CounterEntity].
  Future<Result<CounterEntity>> increment([int amount = 1]);

  /// Decrement the counter by [amount]
  ///
  /// [amount] defaults to 1 if not specified.
  /// Respects the minimum value boundary defined in [CounterEntity].
  Future<Result<CounterEntity>> decrement([int amount = 1]);

  /// Reset the counter to zero
  Future<Result<CounterEntity>> reset();

  /// Set the counter to a specific [value]
  ///
  /// Returns [ValidationFailure] if value is outside allowed boundaries.
  Future<Result<CounterEntity>> setValue(int value);
}
