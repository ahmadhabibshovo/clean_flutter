import '../models/counter_model.dart';

/// Abstract local data source for counter
abstract class CounterLocalDataSource {
  Future<CounterModel> getCounter();
  Future<CounterModel> increment();
  Future<CounterModel> decrement();
  Future<CounterModel> reset();
}

/// Implementation of local data source
class CounterLocalDataSourceImpl implements CounterLocalDataSource {
  static int _counterValue = 0;

  @override
  Future<CounterModel> getCounter() async {
    return CounterModel(value: _counterValue);
  }

  @override
  Future<CounterModel> increment() async {
    _counterValue++;
    return CounterModel(value: _counterValue);
  }

  @override
  Future<CounterModel> decrement() async {
    _counterValue--;
    return CounterModel(value: _counterValue);
  }

  @override
  Future<CounterModel> reset() async {
    _counterValue = 0;
    return CounterModel(value: _counterValue);
  }
}
