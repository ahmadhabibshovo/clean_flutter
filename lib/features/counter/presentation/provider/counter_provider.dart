import 'package:flutter/foundation.dart';

import '../../domain/entities/counter_entity.dart';
import '../../domain/usecases/decrement_counter_usecase.dart';
import '../../domain/usecases/get_counter_usecase.dart';
import '../../domain/usecases/increment_counter_usecase.dart';
import '../../domain/usecases/reset_counter_usecase.dart';

/// Provider class for counter state management
class CounterProvider with ChangeNotifier {
  final GetCounterUseCase getCounterUseCase;
  final IncrementCounterUseCase incrementCounterUseCase;
  final DecrementCounterUseCase decrementCounterUseCase;
  final ResetCounterUseCase resetCounterUseCase;

  CounterEntity? _counter;
  bool _isLoading = false;
  String? _error;

  CounterProvider({
    required this.getCounterUseCase,
    required this.incrementCounterUseCase,
    required this.decrementCounterUseCase,
    required this.resetCounterUseCase,
  });

  // Getters
  CounterEntity? get counter => _counter;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Initialize counter
  Future<void> initCounter() async {
    _setLoading(true);
    try {
      _counter = await getCounterUseCase();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Increment counter
  Future<void> increment() async {
    _setLoading(true);
    try {
      _counter = await incrementCounterUseCase();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Decrement counter
  Future<void> decrement() async {
    _setLoading(true);
    try {
      _counter = await decrementCounterUseCase();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  /// Reset counter
  Future<void> reset() async {
    _setLoading(true);
    try {
      _counter = await resetCounterUseCase();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
