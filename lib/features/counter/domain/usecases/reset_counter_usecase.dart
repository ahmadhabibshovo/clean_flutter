import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

/// Use case for resetting the counter
class ResetCounterUseCase {
  final CounterRepository repository;

  ResetCounterUseCase({required this.repository});

  Future<CounterEntity> call() {
    return repository.reset();
  }
}
