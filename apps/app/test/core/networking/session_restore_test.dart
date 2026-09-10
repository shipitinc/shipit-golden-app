import 'package:flutter_test/flutter_test.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/core/networking/in_memory_auth_success_storage.dart';
import 'package:shipit_golden_app/features/authentication/data/auth_repository.dart';

final _fakeAuth = AuthSuccess(
  authStrategy: 'jwt',
  token: 'access-token-from-login',
  authUserId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
  scopeNames: const {},
  refreshToken: 'refresh-token-from-login',
);

void main() {
  group('FlutterAuthSessionManager session restore', () {
    test(
      'a fresh provider restores a session persisted by an earlier process',
      () async {
        // First launch: the user signs in and the session is persisted to
        // (secure) storage via updateSignedInUser — mirrors real logins, and
        // SecureClientAuthSuccessStorage on mobile/desktop only when the
        // storage is shared across process restarts.
        final storage = InMemoryAuthSuccessStorage();
        final firstProvider = ServerpodClientProvider(storage: storage);
        await firstProvider.authSessionManager.updateSignedInUser(_fakeAuth);

        // App restart: a brand-new provider/session manager reads the same
        // persisted storage (no network).
        final restartProvider = ServerpodClientProvider(storage: storage);
        await restartProvider.authSessionManager.restore();

        expect(restartProvider.authSessionManager.isAuthenticated, isTrue);
        final restored = restartProvider.authSessionManager.authInfo;
        expect(restored, isNotNull);
        expect(restored!.token, _fakeAuth.token);
        expect(restored.authUserId, _fakeAuth.authUserId);
        expect(restored.refreshToken, _fakeAuth.refreshToken);

        // The AuthRepository surface reflects the restored session too.
        final repository = AuthRepository(clientProvider: restartProvider);
        expect(repository.isAuthenticated, isTrue);
        expect(repository.authInfo, isNotNull);
        expect(repository.authInfo!.refreshToken, _fakeAuth.refreshToken);
      },
    );

    test('restore on empty storage stays signed out', () async {
      final provider = ServerpodClientProvider(
        storage: InMemoryAuthSuccessStorage(),
      );
      await provider.authSessionManager.restore();

      expect(provider.authSessionManager.isAuthenticated, isFalse);
      expect(provider.authSessionManager.authInfo, isNull);
    });
  });
}
