import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

/// Use case for decrementing the counter
class DecrementCounterUseCase {
  final CounterRepository repository;

  DecrementCounterUseCase({required this.repository});

  Future<CounterEntity> call() {
    return repository.decrement();
  }
}
