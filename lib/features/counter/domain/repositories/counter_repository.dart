import '../entities/counter_entity.dart';

/// Abstract repository for counter operations
abstract class CounterRepository {
  /// Get the current counter value
  Future<CounterEntity> getCounter();

  /// Increment the counter
  Future<CounterEntity> increment();

  /// Decrement the counter
  Future<CounterEntity> decrement();

  /// Reset the counter to zero
  Future<CounterEntity> reset();
}
