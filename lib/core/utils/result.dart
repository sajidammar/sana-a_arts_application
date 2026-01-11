import 'package:sanaa_artl/core/errors/failures.dart';

/// A class that represents the result of an operation that can either succeed or fail.
///
/// This replaces the need for throwing exceptions in the domain layer.
class Result<T> {
  final T? _value;
  final Failure? _failure;
  final bool isSuccess;

  const Result.success(T value)
    : _value = value,
      _failure = null,
      isSuccess = true;
  const Result.failure(Failure failure)
    : _value = null,
      _failure = failure,
      isSuccess = false;

  /// Returns the value if success, throws exception if failure.
  /// Use [fold] or confirm [isSuccess] before accessing.
  T get value {
    if (!isSuccess)
      throw Exception(
        'Cannot get value from failure result. Check isSuccess or use fold.',
      );
    return _value as T;
  }

  /// Returns the failure if failed, throws exception if success.
  Failure get failure {
    if (isSuccess)
      throw Exception(
        'Cannot get failure from success result. Check !isSuccess or use fold.',
      );
    return _failure!;
  }

  /// Executes [onSuccess] if the result is a success, or [onFailure] if it is a failure.
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) {
    if (isSuccess) {
      return onSuccess(_value as T);
    } else {
      return onFailure(_failure!);
    }
  }
}
