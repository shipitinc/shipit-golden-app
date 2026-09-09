/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:app_client/src/protocol/household.dart' as _i5;
import 'package:app_client/src/protocol/household_member.dart' as _i6;
import 'package:app_client/src/protocol/program.dart' as _i7;
import 'protocol.dart' as _i8;

/// Email/password authentication endpoint.
///
/// Exposes the full email identity-provider surface: [EmailIdpBaseEndpoint.login],
/// registration, password reset and `hasAccount`. The concrete provider is the
/// [EmailIdp] registered on `AuthServices` in `bin/main.dart`.
/// {@category Endpoint}
class EndpointAuth extends _i1.EndpointEmailIdpBase {
  EndpointAuth(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Starts registration but surfaces a duplicate email as a first-class error
  /// instead of Serverpod's default silently-swallow behaviour (built-in
  /// anti account-enumeration).
  ///
  /// NOTE: this deliberately reveals whether an email is already registered —
  /// a product decision for the reference app (see
  /// `email_already_registered_exception.yaml`). Keep the price in mind and
  /// only surface this in a real product if that trade-off is accepted.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>('auth', 'startRegistration', {
        'email': email,
      });

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>('auth', 'login', {
    'email': email,
    'password': password,
  });

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>('auth', 'verifyRegistrationCode', {
    'accountRequestId': accountRequestId,
    'verificationCode': verificationCode,
  });

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'auth',
    'finishRegistration',
    {'registrationToken': registrationToken, 'password': password},
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>('auth', 'startPasswordReset', {
        'email': email,
      });

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>('auth', 'verifyPasswordResetCode', {
    'passwordResetRequestId': passwordResetRequestId,
    'verificationCode': verificationCode,
  });

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>('auth', 'finishPasswordReset', {
    'finishPasswordResetToken': finishPasswordResetToken,
    'newPassword': newPassword,
  });

  @override
  _i3.Future<bool> hasAccount() =>
      caller.callServerEndpoint<bool>('auth', 'hasAccount', {});
}

/// {@category Endpoint}
class EndpointHousehold extends _i2.EndpointRef {
  EndpointHousehold(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'household';

  _i3.Future<_i5.Household> getCurrent() =>
      caller.callServerEndpoint<_i5.Household>('household', 'getCurrent', {});

  _i3.Future<List<_i6.HouseholdMember>> getMembers() =>
      caller.callServerEndpoint<List<_i6.HouseholdMember>>(
        'household',
        'getMembers',
        {},
      );

  _i3.Future<_i6.HouseholdMember> addMember(String name, String email) =>
      caller.callServerEndpoint<_i6.HouseholdMember>('household', 'addMember', {
        'name': name,
        'email': email,
      });

  _i3.Future<void> removeMember(String memberId) =>
      caller.callServerEndpoint<void>('household', 'removeMember', {
        'memberId': memberId,
      });
}

/// Endpoint exposing JWT access-token refresh to the Flutter client.
/// {@category Endpoint}
class EndpointJwtTokens extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtTokens(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtTokens';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtTokens',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// {@category Endpoint}
class EndpointPrograms extends _i2.EndpointRef {
  EndpointPrograms(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'programs';

  _i3.Future<List<_i7.Program>> getAll() =>
      caller.callServerEndpoint<List<_i7.Program>>('programs', 'getAll', {});
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _i1.Caller(client);
    serverpod_auth_core = _i4.Caller(client);
  }

  late final _i1.Caller serverpod_auth_idp;

  late final _i4.Caller serverpod_auth_core;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(_i2.MethodCallContext, Object, StackTrace)? onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i8.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    auth = EndpointAuth(this);
    household = EndpointHousehold(this);
    jwtTokens = EndpointJwtTokens(this);
    programs = EndpointPrograms(this);
    modules = Modules(this);
  }

  late final EndpointAuth auth;

  late final EndpointHousehold household;

  late final EndpointJwtTokens jwtTokens;

  late final EndpointPrograms programs;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'auth': auth,
    'household': household,
    'jwtTokens': jwtTokens,
    'programs': programs,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
