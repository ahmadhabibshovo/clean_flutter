import '../../domain/entities/counter_entity.dart';
import '../models/counter_model.dart';

/// Abstract local data source for counter operations
///
/// This interface defines the contract for local data operations.
/// Following the Dependency Inversion Principle, the repository
/// depends on this abstraction, not concrete implementations.
///
/// Benefits:
/// - Easy testing with mock implementations
/// - Swapping storage mechanisms (memory, SharedPreferences, SQLite, etc.)
/// - Clear separation between data access and business logic
abstract class CounterLocalDataSource {
  /// Retrieve the current counter value
  Future<CounterModel> getCounter();

  /// Increment the counter by a specified amount
  Future<CounterModel> increment([int by = 1]);

  /// Decrement the counter by a specified amount
  Future<CounterModel> decrement([int by = 1]);

  /// Reset the counter to zero
  Future<CounterModel> reset();

  /// Set counter to a specific value
  Future<CounterModel> setValue(int value);
}

/// In-memory implementation of counter local data source
///
/// This implementation uses a static variable for persistence across
/// instances. In a production app, you would replace this with
/// SharedPreferences, Hive, SQLite, or another persistent storage.
///
/// The architecture allows easy swapping of implementations without
/// affecting other layers of the application.
class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  /// Static storage to persist across instances
  /// In production, this would use SharedPreferences or similar
  static CounterModel _counter = CounterModel.zero();

  @override
  Future<CounterModel> getCounter() async {
    // Simulate async operation (would be real with SharedPreferences)
    await Future.delayed(const Duration(milliseconds: 5));
    return _counter;
  }

  @override
  Future<CounterModel> increment([int by = 1]) async {
    _counter = _counter.incrementModel(by);
    return _counter;
  }

  @override
  Future<CounterModel> decrement([int by = 1]) async {
    _counter = _counter.decrementModel(by);
    return _counter;
  }

  @override
  Future<CounterModel> reset() async {
    _counter = _counter.resetModel();
    return _counter;
  }

  @override
  Future<CounterModel> setValue(int value) async {
    final clampedValue = value.clamp(
      CounterEntity.minValue,
      CounterEntity.maxValue,
    );
    _counter = _counter.copyWith(
      value: clampedValue,
      lastUpdated: DateTime.now(),
    );
    return _counter;
  }
}

/// SharedPreferences-based implementation (template for production use)
/// 
/// Example of how to implement persistent storage while maintaining
/// the same interface. This class would be used in production.
/// 
/// ```dart
/// class CounterSharedPrefsDataSource implements CounterLocalDataSource {
///   final SharedPreferences _prefs;
///   static const _key = 'counter_value';
///   
///   CounterSharedPrefsDataSource(this._prefs);
///   
///   @override
///   Future<CounterModel> getCounter() async {
///     final value = _prefs.getInt(_key) ?? 0;
///     return CounterModel(value: value, lastUpdated: DateTime.now());
///   }
///   
///   @override
///   Future<CounterModel> increment([int by = 1]) async {
///     final current = _prefs.getInt(_key) ?? 0;
///     final newValue = (current + by).clamp(minValue, maxValue);
///     await _prefs.setInt(_key, newValue);
///     return CounterModel(value: newValue, lastUpdated: DateTime.now());
///   }
///   // ... other methods
/// }
/// ```

