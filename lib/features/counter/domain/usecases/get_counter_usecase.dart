import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

/// Use case for getting the current counter value
class GetCounterUseCase {
  final CounterRepository repository;

  GetCounterUseCase({required this.repository});

  Future<CounterEntity> call() {
    return repository.getCounter();
  }
}
