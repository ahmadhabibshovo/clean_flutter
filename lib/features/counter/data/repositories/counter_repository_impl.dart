import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/types/result.dart';
import '../../domain/entities/counter_entity.dart';
import '../../domain/repositories/counter_repository.dart';
import '../datasources/counter_local_datasource.dart';

/// Implementation of counter repository with comprehensive error handling
///
/// This implementation:
/// - Catches all exceptions from data sources
/// - Maps exceptions to appropriate failures
/// - Returns type-safe Result objects
/// - Ensures the domain layer never sees exceptions
class CounterRepositoryImpl implements CounterRepository {
  final CounterLocalDataSource localDataSource;

  CounterRepositoryImpl({required this.localDataSource});

  @override
  Future<Result<CounterEntity>> getCounter() async {
    try {
      final model = await localDataSource.getCounter();
      return Result.success(model.toEntity());
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(message: e.message));
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<CounterEntity>> increment([int amount = 1]) async {
    try {
      // Validate amount
      if (amount <= 0) {
        return Result.failure(
          const ValidationFailure(message: 'Increment amount must be positive'),
        );
      }

      final model = await localDataSource.increment(amount);
      return Result.success(model.toEntity());
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(message: e.message));
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<CounterEntity>> decrement([int amount = 1]) async {
    try {
      // Validate amount
      if (amount <= 0) {
        return Result.failure(
          const ValidationFailure(message: 'Decrement amount must be positive'),
        );
      }

      final model = await localDataSource.decrement(amount);
      return Result.success(model.toEntity());
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(message: e.message));
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<CounterEntity>> reset() async {
    try {
      final model = await localDataSource.reset();
      return Result.success(model.toEntity());
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(message: e.message));
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }

  @override
  Future<Result<CounterEntity>> setValue(int value) async {
    try {
      // Validate value boundaries
      if (value < CounterEntity.minValue || value > CounterEntity.maxValue) {
        return Result.failure(
          ValidationFailure(
            message:
                'Value must be between ${CounterEntity.minValue} and ${CounterEntity.maxValue}',
            fieldErrors: {'value': 'Out of range'},
          ),
        );
      }

      final model = await localDataSource.setValue(value);
      return Result.success(model.toEntity());
    } on CacheException catch (e) {
      return Result.failure(CacheFailure(message: e.message));
    } catch (e, stackTrace) {
      return Result.failure(UnexpectedFailure.fromException(e, stackTrace));
    }
  }
}
