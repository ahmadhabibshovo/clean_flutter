import '../../../../core/types/result.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/counter_entity.dart';
import '../repositories/counter_repository.dart';

/// Parameters for incrementing counter
class IncrementParams extends Params {
  final int amount;

  const IncrementParams({this.amount = 1});

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

/// Use case for incrementing the counter
///
/// This use case validates the increment amount before
/// delegating to the repository.
///
/// Usage:
/// ```dart
/// final result = await incrementCounterUseCase(IncrementParams(amount: 5));
/// result.fold(
///   onFailure: (failure) => handleError(failure),
///   onSuccess: (counter) => displayCounter(counter),
/// );
/// ```
class IncrementCounterUseCase extends UseCase<CounterEntity, IncrementParams> {
  final CounterRepository repository;

  IncrementCounterUseCase({required this.repository});

  @override
  Future<Result<CounterEntity>> call(IncrementParams params) {
    return repository.increment(params.amount);
  }
}
