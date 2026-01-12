import '../types/result.dart';

/// Base UseCase
abstract class UseCase<T, P> {
  Future<Result<T>> call(P params);
}

/// Base params marker
abstract class Params {
  const Params();
}

class NoParams extends Params {
  const NoParams();
}
