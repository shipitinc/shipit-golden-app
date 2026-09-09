import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    show AuthSuccess;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    hide Protocol;
import 'package:shipit_golden_server/src/auth/auth_setup.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart'
    show EmailAlreadyRegisteredException;
import 'package:test/test.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  group('Email IDP auth', () {
    var email =
        'golden_rules_${DateTime.now().millisecondsSinceEpoch}@example.com';
    const password = 'sup3r-s3cret!';

    late AuthSuccess registered;

    withServerpod(
      'Given a newly requested registration account',
      (sessionBuilder, endpoints) {
        setUp(() {
          // The integration test harness builds its own Serverpod without
          // running `bin/main.dart`, so the AuthServices singleton must be
          // configured per group. A fixed verification code keeps the
          // registration flow fully deterministic.
          configureAuthServicesSingleton(
            registrationVerificationCodeGenerator: () => '000000',
          );
        });
        test(
          'then verify + finish completes the signup and issues tokens',
          () async {
            final accountRequestId = await endpoints.auth.startRegistration(
              sessionBuilder,
              email: email,
            );
            expect(accountRequestId, isNotNull);

            final verificationToken = await endpoints.auth
                .verifyRegistrationCode(
                  sessionBuilder,
                  accountRequestId: accountRequestId,
                  verificationCode: '000000',
                );
            expect(verificationToken, isNotEmpty);

            registered = await endpoints.auth.finishRegistration(
              sessionBuilder,
              registrationToken: verificationToken,
              password: password,
            );
            expect(registered.token, isNotEmpty);
            expect(registered.refreshToken, isNotEmpty);
          },
        );

        test(
          'then hasAccount does not leak account existence anonymously',
          () async {
            // `hasAccount` reflects the session's own linked email account; an
            // unauthenticated session must not learn whether an account exists.
            final has = await endpoints.auth.hasAccount(sessionBuilder);
            expect(has, isFalse);
          },
        );

        test('then login with the created credentials succeeds', () async {
          final success = await endpoints.auth.login(
            sessionBuilder,
            email: email,
            password: password,
          );
          expect(success.token, isNotEmpty);
          expect(success.refreshToken, isNotEmpty);
        });

        test('then login with a wrong password is rejected', () async {
          expect(
            () => endpoints.auth.login(
              sessionBuilder,
              email: email,
              password: 'wrong-password',
            ),
            throwsA(isA<EmailAccountLoginException>()),
          );
        });

        test(
          'then registering the same email again surfaces a duplicate-account '
          'error instead of silently swallowing it',
          () async {
            // Serverpod's built-in email IDP would return a fake request id
            // (anti account-enumeration); the golden app deliberately surfaces
            // the duplicate for product clarity — see
            // EmailAlreadyRegisteredException.
            expect(
              () => endpoints.auth.startRegistration(
                sessionBuilder,
                email: email,
              ),
              throwsA(isA<EmailAlreadyRegisteredException>()),
            );
          },
        );
      },
      rollbackDatabase: RollbackDatabase.disabled,
    );
  });

  group('Protected application endpoints', () {
    withServerpod('Given an unauthenticated session', (
      sessionBuilder,
      endpoints,
    ) {
      setUp(() {
        configureAuthServicesSingleton(
          registrationVerificationCodeGenerator: () => '000000',
        );
      });
      test('then household requires login', () async {
        final session = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );
        expect(
          () => endpoints.household.getCurrent(session),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });

      test('then programs requires login too', () async {
        final session = sessionBuilder.copyWith(
          authentication: AuthenticationOverride.unauthenticated(),
        );
        expect(
          () => endpoints.programs.getAll(session),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });
  });
}
