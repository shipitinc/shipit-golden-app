import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shipit_golden_app/core/errors/app_failure.dart';

part 'result.freezed.dart';

/// A sealed result type used across application repositories to represent the
/// outcome of an operation: either a [Success] value or a [Failure].
@freezed
sealed class Result<T> with _$Result<T> {
  const factory Result.success(T value) = Success<T>;
  const factory Result.failure(AppFailure failure) = Failure<T>;
}

extension ResultExtension<T> on Result<T> {
  T getOrThrow() {
    return switch (this) {
      Success(:final value) => value,
      Failure(:final failure) => throw failure,
    };
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
}
