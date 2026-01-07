import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

/// Use case for getting the current counter value
///
/// This use case follows the Single Responsibility Principle:
/// its only job is to retrieve the current counter value.
///
/// Usage:
/// ```dart
/// final result = await getCounterUseCase(NoParams());
/// result.fold(
///   onFailure: (failure) => handleError(failure),
///   onSuccess: (counter) => displayCounter(counter),
/// );
/// ```
class GetCounterUseCase extends UseCase<CounterEntity, NoParams> {
  final CounterRepository repository;

  GetCounterUseCase({required this.repository});

  @override
  Future<Result<CounterEntity>> call(NoParams params) {
    return repository.getCounter();
  }
}
