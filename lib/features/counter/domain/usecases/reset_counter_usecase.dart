import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

/// Use case for resetting the counter to zero
///
/// This use case has no parameters since reset always
/// returns the counter to zero.
class ResetCounterUseCase extends UseCase<CounterEntity, NoParams> {
  final CounterRepository repository;

  ResetCounterUseCase({required this.repository});

  @override
  Future<Result<CounterEntity>> call(NoParams params) {
    return repository.reset();
  }
}
