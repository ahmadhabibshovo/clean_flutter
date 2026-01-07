import 'package:flutter/foundation.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/counter_entity.dart';
import '../../domain/usecases/decrement_counter_usecase.dart';
import '../../domain/usecases/get_counter_usecase.dart';
import '../../domain/usecases/increment_counter_usecase.dart';
import '../../domain/usecases/reset_counter_usecase.dart';

/// UI state enum for better state management
enum CounterState { initial, loading, loaded, error }

/// Provider class for counter state management
///
/// This provider follows best practices:
/// - Uses Result pattern for error handling (no try/catch)
/// - Immutable state updates
/// - Clear state machine (initial → loading → loaded/error)
/// - Optimistic updates with rollback capability
class CounterProvider with ChangeNotifier {
  final GetCounterUseCase getCounterUseCase;
  final IncrementCounterUseCase incrementCounterUseCase;
  final DecrementCounterUseCase decrementCounterUseCase;
  final ResetCounterUseCase resetCounterUseCase;

  CounterEntity _counter = CounterEntity.zero();
  CounterState _state = CounterState.initial;
  Failure? _failure;

  CounterProvider({
    required this.getCounterUseCase,
    required this.incrementCounterUseCase,
    required this.decrementCounterUseCase,
    required this.resetCounterUseCase,
  });

  // Getters
  CounterEntity get counter => _counter;
  CounterState get state => _state;
  bool get isLoading => _state == CounterState.loading;
  bool get hasError => _state == CounterState.error;
  Failure? get failure => _failure;
  String? get errorMessage => _failure?.message;

  /// Convenience getter for the counter value
  int get value => _counter.value;

  /// Initialize counter - should be called on widget initialization
  Future<void> initCounter() async {
    _setState(CounterState.loading);

    final result = await getCounterUseCase(const NoParams());

    result.fold(
      onFailure: (failure) {
        _failure = failure;
        _setState(CounterState.error);
      },
      onSuccess: (counter) {
        _counter = counter;
        _failure = null;
        _setState(CounterState.loaded);
      },
    );
  }

  /// Increment counter by [amount] (default: 1)
  Future<void> increment([int amount = 1]) async {
    // Store previous value for potential rollback
    final previousCounter = _counter;

    // Optimistic update
    _counter = _counter.increment(amount);
    notifyListeners();

    final result = await incrementCounterUseCase(
      IncrementParams(amount: amount),
    );

    result.fold(
      onFailure: (failure) {
        // Rollback on failure
        _counter = previousCounter;
        _failure = failure;
        _setState(CounterState.error);
      },
      onSuccess: (counter) {
        _counter = counter;
        _failure = null;
        _setState(CounterState.loaded);
      },
    );
  }

  /// Decrement counter by [amount] (default: 1)
  Future<void> decrement([int amount = 1]) async {
    // Store previous value for potential rollback
    final previousCounter = _counter;

    // Optimistic update
    _counter = _counter.decrement(amount);
    notifyListeners();

    final result = await decrementCounterUseCase(
      DecrementParams(amount: amount),
    );

    result.fold(
      onFailure: (failure) {
        // Rollback on failure
        _counter = previousCounter;
        _failure = failure;
        _setState(CounterState.error);
      },
      onSuccess: (counter) {
        _counter = counter;
        _failure = null;
        _setState(CounterState.loaded);
      },
    );
  }

  /// Reset counter to zero
  Future<void> reset() async {
    // Store previous value for potential rollback
    final previousCounter = _counter;

    // Optimistic update
    _counter = CounterEntity.zero();
    notifyListeners();

    final result = await resetCounterUseCase(const NoParams());

    result.fold(
      onFailure: (failure) {
        // Rollback on failure
        _counter = previousCounter;
        _failure = failure;
        _setState(CounterState.error);
      },
      onSuccess: (counter) {
        _counter = counter;
        _failure = null;
        _setState(CounterState.loaded);
      },
    );
  }

  /// Clear any error state
  void clearError() {
    if (_state == CounterState.error) {
      _failure = null;
      _setState(CounterState.loaded);
    }
  }

  void _setState(CounterState newState) {
    _state = newState;
    notifyListeners();
  }
}
