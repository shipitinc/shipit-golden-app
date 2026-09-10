import 'dart:async';

import 'package:app_client/app_client.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart';
import 'package:shipit_golden_app/core/errors/app_failure.dart';
import 'package:shipit_golden_app/core/errors/error_translator.dart';
import 'package:shipit_golden_app/core/networking/session_expired_notifier.dart';

void main() {
  group('mapAppFailure', () {
    test(
      'surfaces a duplicate email as a user-correctable validation error',
      () {
        final failure = mapAppFailure(api.EmailAlreadyRegisteredException());
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, contains('Try signing in instead'));
      },
    );

    test(
      'surfaces an expired verification code with an actionable message',
      () {
        final exception = EmailAccountRequestException(
          reason: EmailAccountRequestExceptionReason.expired,
        );
        final failure = mapAppFailure(exception);
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, contains('request a new one'));
        expect(failure.message, isNot(contains('Exception')));
      },
    );

    test('surfaces an invalid verification code without leaking internals', () {
      final failure = mapAppFailure(
        EmailAccountRequestException(
          reason: EmailAccountRequestExceptionReason.invalid,
        ),
      );
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, contains('incorrect'));
    });

    test('surfaces a password policy violation with an actionable message', () {
      final failure = mapAppFailure(
        EmailAccountRequestException(
          reason: EmailAccountRequestExceptionReason.policyViolation,
        ),
      );
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, contains('stronger one'));
    });

    test(
      'surfaces too many verification attempts with an actionable message',
      () {
        final failure = mapAppFailure(
          EmailAccountRequestException(
            reason: EmailAccountRequestExceptionReason.tooManyAttempts,
          ),
        );
        expect(failure, isA<ValidationFailure>());
        expect(failure.message, contains('later'));
      },
    );

    test('keeps unknown registration requests generic', () {
      final failure = mapAppFailure(
        EmailAccountRequestException(
          reason: EmailAccountRequestExceptionReason.unknown,
        ),
      );
      expect(failure, isA<ValidationFailure>());
      expect(failure.message, contains('try again'));
    });

    test('maps an unreachable server to a network failure', () {
      final failure = mapAppFailure(
        const ServerpodClientException('Connection refused', -1),
      );
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, contains('check your connection'));
    });

    test('keeps real server faults as generic server errors', () {
      final failure = mapAppFailure(
        const ServerpodClientException('boom', 500),
      );
      expect(failure, isA<ServerFailure>());
      expect(failure.message, isNot(contains('boom')));
    });

    test('maps invalid login credentials to a safe auth failure', () {
      final failure = mapAppFailure(
        EmailAccountLoginException(
          reason: EmailAccountLoginExceptionReason.invalidCredentials,
        ),
      );
      expect(failure, isA<AuthFailure>());
      expect(failure.message, 'Incorrect email or password.');
      expect((failure as AuthFailure).code, 'login_invalidCredentials');
    });

    test('keeps unknown exceptions generic without leaking the cause', () {
      final failure = mapAppFailure(StateError('internal_stack_traces_only'));
      expect(failure, isA<UnknownFailure>());
      expect(failure.message, isNot(contains('internal_stack_traces_only')));
    });

    test('announces listeners when a session-expired failure is mapped', () {
      var announced = false;
      void listener() => announced = true;
      SessionExpiredNotifier.add(listener);
      addTearDown(() => SessionExpiredNotifier.remove(listener));

      mapAppFailure(ServerpodClientUnauthorized());

      expect(
        announced,
        isTrue,
        reason:
            'session_expired must reach the app shell so the router can '
            'drop the user back to login.',
      );
    });

    test('does not announce non-expiry failures', () {
      var announced = false;
      void listener() => announced = true;
      SessionExpiredNotifier.add(listener);
      addTearDown(() => SessionExpiredNotifier.remove(listener));

      mapAppFailure(api.EmailAlreadyRegisteredException());

      expect(announced, isFalse);
    });
  });

  test('maps a transport timeout to a network failure', () {
    final failure = mapAppFailure(TimeoutException('Request timed out'));
    expect(failure, isA<NetworkFailure>());
    expect(failure.message, contains('timed out'));
  });

  group('loginFailureMessage', () {
    test('rejects invalid credentials with a generic, safe message', () {
      expect(
        loginFailureMessage(
          EmailAccountLoginException(
            reason: EmailAccountLoginExceptionReason.invalidCredentials,
          ),
        ),
        'Incorrect email or password.',
      );
    });
  });
}
