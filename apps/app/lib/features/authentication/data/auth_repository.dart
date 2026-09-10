import 'package:app_client/app_client.dart' as api;
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:shipit_golden_app/core/core.dart';

/// Handles authentication and registration via the shared Serverpod client.
class AuthRepository {
  final ServerpodClientProvider _clientProvider;

  AuthRepository({ServerpodClientProvider? clientProvider})
    : _clientProvider = clientProvider ?? ServerpodClientProvider.shared;

  api.Client get _client => _clientProvider.client;
  FlutterAuthSessionManager get _sessionManager =>
      _clientProvider.authSessionManager;

  bool get isAuthenticated => _sessionManager.isAuthenticated;
  AuthSuccess? get authInfo => _sessionManager.authInfo;

  /// Restores and validates any persisted session.
  Future<void> restoreSession() => _sessionManager.initialize();

  Future<Result<AuthSuccess>> login(String email, String password) async {
    try {
      final success = await _client.auth.login(
        email: email,
        password: password,
      );
      await _sessionManager.updateSignedInUser(success);
      return Result.success(success);
    } catch (e) {
      return Result.failure(mapAppFailure(e));
    }
  }

  Future<Result<UuidValue>> startRegistration(String email) async {
    try {
      final requestId = await _client.auth.startRegistration(email: email);
      return Result.success(requestId);
    } catch (e) {
      return Result.failure(mapAppFailure(e));
    }
  }

  Future<Result<AuthSuccess>> completeRegistration({
    required String accountRequestId,
    required String verificationCode,
    required String password,
  }) async {
    try {
      final registrationToken = await _client.auth.verifyRegistrationCode(
        accountRequestId: UuidValue.fromString(accountRequestId),
        verificationCode: verificationCode,
      );
      final success = await _client.auth.finishRegistration(
        registrationToken: registrationToken,
        password: password,
      );
      await _sessionManager.updateSignedInUser(success);
      return Result.success(success);
    } catch (e) {
      return Result.failure(mapAppFailure(e));
    }
  }

  Future<void> logout() => _sessionManager.signOutDevice();
}
