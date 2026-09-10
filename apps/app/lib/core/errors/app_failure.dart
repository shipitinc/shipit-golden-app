import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

@freezed
sealed class AppFailure with _$AppFailure {
  const factory AppFailure.network({required String message, String? code}) =
      NetworkFailure;

  const factory AppFailure.auth({required String message, String? code}) =
      AuthFailure;

  const factory AppFailure.authorization({
    required String message,
    String? code,
  }) = AuthorizationFailure;

  const factory AppFailure.validation({
    required String message,
    Map<String, String>? fields,
  }) = ValidationFailure;

  const factory AppFailure.server({required String message, int? statusCode}) =
      ServerFailure;

  const factory AppFailure.unavailable({required String message}) =
      UnavailableFailure;

  const factory AppFailure.unknown({required String message, Object? cause}) =
      UnknownFailure;
}

extension AppFailureExtension on AppFailure {
  /// User-facing message. Auth messages are already complete sentences (e.g.
  /// "Incorrect email or password.", "Your session has expired. Please sign in
  /// again."), so no blanket prefix is prepended.
  String get userMessage {
    return switch (this) {
      NetworkFailure(:final message) => 'Network error: $message',
      AuthFailure(:final message) => message,
      AuthorizationFailure(:final message) => 'Access denied: $message',
      ValidationFailure(:final message) => 'Validation error: $message',
      ServerFailure(:final message) => 'Server error: $message',
      UnavailableFailure(:final message) => 'Service unavailable: $message',
      UnknownFailure(:final message) =>
        'An unexpected error occurred: $message',
    };
  }
}
