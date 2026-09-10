import 'dart:async';

import 'package:app_client/app_client.dart' as api;
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:shipit_golden_app/core/errors/app_failure.dart';
import 'package:shipit_golden_app/core/networking/session_expired_notifier.dart';

/// Maps transport, protocol and application exceptions to user-safe
/// [AppFailure]s — the single canonical mapping for the whole app.
///
/// Messages are intentionally user-facing: they do not leak internal
/// exception text or stack traces into the UI.
///
/// Genuine, user-correctable causes (e.g. expired verification codes, an
/// email that is already registered, invalid credentials) are surfaced with an
/// actionable message. Developer-internal errors (bad payloads, server faults,
/// unexpected exceptions) stay generic so they never expose implementation
/// detail.
///
/// Side effect: a `session_expired` result is announced through
/// [SessionExpiredNotifier] so the app shell can end the session and return
/// the user to the login screen (see [SessionExpiredNotifier]).
AppFailure mapAppFailure(Object error, {String? operation}) {
  final failure = switch (error) {
    // Duplicate email: Serverpod's built-in email IDP silently swallows this
    // on the login path (anti account-enumeration; see
    // AuthEndpoint.startRegistration), so the translator surfaces it as a
    // user-correctable error for whoever re-threw it.
    api.EmailAlreadyRegisteredException() => AppFailure.validation(
      message:
          'An account already exists for this email address. '
          'Try signing in instead.',
    ),
    EmailAccountLoginException() => AppFailure.auth(
      message: loginFailureMessage(error),
      code: 'login_${error.reason.name}',
    ),
    EmailAccountRequestException() => AppFailure.validation(
      message: registrationRequestFailureMessage(error),
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
    ServerpodClientException(statusCode: final statusCode)
        when statusCode == 0 || statusCode == -1 =>
      AppFailure.network(
        message:
            'Could not reach the server. Please check your connection '
            'and try again.',
        code: 'server_unreachable',
      ),
    ServerpodClientException() => AppFailure.server(
      message: 'The server responded with an unexpected error.',
      statusCode: error.statusCode,
    ),
    TimeoutException() => AppFailure.network(
      message: 'The request timed out. Please check your connection.',
      code: 'timeout',
    ),
    _ => _unknownFailure(error, operation),
  };
  SessionExpiredNotifier.announceIfExpired(failure);
  return failure;
}

/// Builds the generic unknown failure and records the original error so it is
/// not silently discarded (the cause is otherwise only observable here).
AppFailure _unknownFailure(Object error, String? operation) {
  debugPrint('[mapAppFailure] operation=$operation; unhandled error=$error');
  return AppFailure.unknown(
    message: 'An unexpected error occurred. Please try again.',
    cause: error,
  );
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

/// Human-readable message for a thrown [EmailAccountRequestException].
///
/// Granular only for genuinely user-correctable causes; everything else
/// (including [EmailAccountRequestExceptionReason.unknown]) falls back to a
/// generic retry message.
String registrationRequestFailureMessage(EmailAccountRequestException error) {
  return switch (error.reason) {
    EmailAccountRequestExceptionReason.expired =>
      'This verification code has expired. Please request a new one.',
    EmailAccountRequestExceptionReason.invalid =>
      'This verification code is incorrect. Please check it and try again.',
    EmailAccountRequestExceptionReason.policyViolation =>
      'That password does not meet the requirements. Please choose a '
          'stronger one.',
    EmailAccountRequestExceptionReason.tooManyAttempts =>
      'Too many verification attempts. Please request a new code and try '
          'again later.',
    EmailAccountRequestExceptionReason.unknown =>
      'Registration could not be completed. Please request a new verification '
          'code and try again.',
  };
}
