/// Core layer exports
///
/// This barrel file exports all core functionality for easy importing.
/// Following the principle of explicit dependencies, each feature should
/// import only what it needs from the core layer.

// Error handling
export 'error/exceptions.dart';
export 'error/failures.dart';

// Types
export 'types/result.dart';

// Use cases
export 'usecases/usecase.dart';

// Dependency Injection
export 'di/service_locator.dart';
