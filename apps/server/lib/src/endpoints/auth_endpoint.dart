import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';
import 'package:shipit_golden_server/src/generated/protocol.dart';

/// Email/password authentication endpoint.
///
/// Exposes the full email identity-provider surface: [EmailIdpBaseEndpoint.login],
/// registration, password reset and `hasAccount`. The concrete provider is the
/// [EmailIdp] registered on `AuthServices` in `bin/main.dart`.
class AuthEndpoint extends EmailIdpBaseEndpoint {
  /// Starts registration but surfaces a duplicate email as a first-class error
  /// instead of Serverpod's default silently-swallow behaviour (built-in
  /// anti account-enumeration).
  ///
  /// NOTE: this deliberately reveals whether an email is already registered —
  /// a product decision for the reference app (see
  /// `email_already_registered_exception.yaml`). Keep the price in mind and
  /// only surface this in a real product if that trade-off is accepted.
  @override
  Future<UuidValue> startRegistration(
    final Session session, {
    required final String email,
  }) async {
    final existingAccounts = await EmailAccount.db.count(
      session,
      where: (account) => account.email.equals(email),
    );
    if (existingAccounts > 0) {
      throw EmailAlreadyRegisteredException();
    }
    return super.startRegistration(session, email: email);
  }
}
