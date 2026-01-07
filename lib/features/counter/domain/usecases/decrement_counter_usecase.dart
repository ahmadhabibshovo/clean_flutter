import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

/// Parameters for decrementing counter
class DecrementParams extends Params {
  final int amount;

  const DecrementParams({this.amount = 1});

  @override
  List<Object?> get props => [amount];

  @override
  ValidationResult validate() {
    if (amount <= 0) {
      return ValidationResult.invalid('Must be a positive integer', {
        'amount': 'Must be positive',
      });
    }
    return ValidationResult.valid();
  }
}

/// Use case for decrementing the counter
///
/// This use case validates the decrement amount before
/// delegating to the repository.
class DecrementCounterUseCase extends UseCase<CounterEntity, DecrementParams> {
  final CounterRepository repository;

  DecrementCounterUseCase({required this.repository});

  @override
  Future<Result<CounterEntity>> call(DecrementParams params) {
    return repository.decrement(params.amount);
  }
}
