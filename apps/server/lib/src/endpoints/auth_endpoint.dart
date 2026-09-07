import 'package:serverpod_auth_idp_server/providers/email.dart';

/// Email/password authentication endpoint.
///
/// Exposes the full email identity-provider surface: [EmailIdpBaseEndpoint.login],
/// registration, password reset and `hasAccount`. The concrete provider is the
/// [EmailIdp] registered on `AuthServices` in `bin/main.dart`.
class AuthEndpoint extends EmailIdpBaseEndpoint {}
