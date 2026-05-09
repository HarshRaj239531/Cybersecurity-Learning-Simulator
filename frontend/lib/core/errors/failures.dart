abstract class AppFailure {
  final String message;
  const AppFailure(this.message);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure([super.message = 'Network error. Please check your connection.']);
}

class TimeoutFailure extends AppFailure {
  const TimeoutFailure([super.message = 'Request timed out. Please try again.']);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure([super.message = 'Session expired. Please login again.']);
}

class ServerFailure extends AppFailure {
  const ServerFailure([super.message = 'Server error. Please try later.']);
}

class ValidationFailure extends AppFailure {
  const ValidationFailure(super.message);
}

class NotFoundFailure extends AppFailure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

class CacheFailure extends AppFailure {
  const CacheFailure([super.message = 'Cache error occurred.']);
}
