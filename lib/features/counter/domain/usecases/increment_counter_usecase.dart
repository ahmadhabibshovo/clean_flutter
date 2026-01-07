import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

/// Use case for incrementing the counter
class IncrementCounterUseCase {
  final CounterRepository repository;

  IncrementCounterUseCase({required this.repository});

  Future<CounterEntity> call() {
    return repository.increment();
  }
}
