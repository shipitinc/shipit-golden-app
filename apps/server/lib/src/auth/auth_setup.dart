import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

/// Wires the Serverpod auth layer (JWT token managers + email identity provider)
/// onto [pod].
///
/// Centralized so that `bin/main.dart` and the integration test harness
/// configure auth identically instead of drifting.
///
/// In non-development run modes the [sendRegistrationVerificationCode] and
/// [sendPasswordResetVerificationCode] delivery callbacks must be replaced with a
/// real email channel; no code delivery is provided by default.
void configureAuthServices(
  Serverpod pod, {
  String Function()? registrationVerificationCodeGenerator,
}) {
  pod.initializeAuthServices(
    tokenManagerBuilders: [JwtConfigFromPasswords()],
    identityProviderBuilders: [
      _emailIdpConfig(registrationVerificationCodeGenerator),
    ],
  );
}

/// Initializes the [AuthServices] singleton without a Serverpod instance.
///
/// Used by the integration test harness, which constructs its own Serverpod
/// without running `bin/main.dart`.
void configureAuthServicesSingleton({
  String Function()? registrationVerificationCodeGenerator,
}) {
  AuthServices.set(
    tokenManagerBuilders: [JwtConfigFromPasswords()],
    identityProviderBuilders: [
      _emailIdpConfig(registrationVerificationCodeGenerator),
    ],
  );
}

EmailIdpConfigFromPasswords _emailIdpConfig(
  String Function()? registrationVerificationCodeGenerator,
) {
  return EmailIdpConfigFromPasswords(
    registrationVerificationCodeGenerator:
        registrationVerificationCodeGenerator ??
        defaultVerificationCodeGenerator,
    sendRegistrationVerificationCode:
        (
          Session session, {
          required String email,
          required UuidValue accountRequestId,
          required String verificationCode,
          required Transaction? transaction,
        }) async {
          _logVerificationCode(
            session,
            'Email verification',
            email,
            verificationCode,
          );
        },
    sendPasswordResetVerificationCode:
        (
          Session session, {
          required String email,
          required UuidValue passwordResetRequestId,
          required String verificationCode,
          required Transaction? transaction,
        }) async {
          _logVerificationCode(
            session,
            'Password reset',
            email,
            verificationCode,
          );
        },
  );
}

/// Logs a verification code to the server console — but only in development.
///
/// The development workflow has no email provider, so the code is printed for
/// the operator to read. In any other run mode the code itself is never logged;
/// the stub delivery channel only reports that delivery was requested. A real
/// email channel must replace these callbacks in non-development modes (see
/// [configureAuthServices]).
void _logVerificationCode(
  Session session,
  String verb,
  String email,
  String verificationCode,
) {
  if (session.server.runMode == ServerpodRunMode.development) {
    session.log(
      '[dev] $verb code for $email: $verificationCode',
      level: LogLevel.info,
    );
  } else {
    session.log(
      '$verb code requested for $email; no delivery channel configured in '
      '${session.server.runMode} mode',
      level: LogLevel.info,
    );
  }
}
