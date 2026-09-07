import 'dart:async';

import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:shipit_golden_app/core/errors/app_failure.dart';

/// Maps transport, protocol and application exceptions to user-safe
/// [AppFailure]s.
///
/// Messages are intentionally user-facing: they do not leak internal
/// exception text or stack traces into the UI.
AppFailure mapAppFailure(Object error, {String? operation}) {
  return switch (error) {
    EmailAccountRequestException() => AppFailure.validation(
      message:
          'Registration could not be completed. Please request a new '
          'verification code and try again.',
    ),
    AuthUserBlockedException() => AppFailure.auth(
      message: 'This account has been locked. Please contact support.',
      code: 'account_blocked',
    ),
    ServerpodClientUnauthorized() => AppFailure.auth(
      message: 'Your session has expired. Please sign in again.',
      code: 'session_expired',
    ),
    ServerpodClientForbidden() => AppFailure.authorization(
      message: 'You do not have permission to perform this action.',
      code: 'forbidden',
    ),
    ServerpodClientNotFound() => AppFailure.server(
      message: 'The requested resource could not be found.',
      statusCode: 404,
    ),
    ServerpodClientInternalServerError() => AppFailure.server(
      message: 'Something went wrong on our end. Please try again.',
      statusCode: 500,
    ),
    ServerpodClientBadRequest() => AppFailure.validation(
      message: 'The request was not valid. Please check your input.',
    ),
    ServerpodClientException() => AppFailure.server(
      message: 'The server responded with an unexpected error.',
      statusCode: error.statusCode,
    ),
    TimeoutException() => AppFailure.network(
      message: 'The request timed out. Please check your connection.',
      code: 'timeout',
    ),
    _ => AppFailure.unknown(
      message: 'An unexpected error occurred. Please try again.',
      cause: error,
    ),
  };
}

/// Human-readable message for a thrown [EmailAccountLoginException].
String loginFailureMessage(EmailAccountLoginException e) {
  return switch (e.reason) {
    EmailAccountLoginExceptionReason.invalidCredentials =>
      'Incorrect email or password.',
    EmailAccountLoginExceptionReason.tooManyAttempts =>
      'Too many sign-in attempts. Please try again later.',
    EmailAccountLoginExceptionReason.unknown =>
      'Sign in failed. Please try again.',
  };
}
