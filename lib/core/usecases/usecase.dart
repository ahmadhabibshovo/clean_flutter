import 'package:dartz/dartz.dart';

import '../errors/failures.dart';

/// Base UseCase
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

/// Base params marker
abstract class Params {
  const Params();
}

class NoParams extends Params {
  const NoParams();
}
