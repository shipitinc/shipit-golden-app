import 'package:app_client/app_client.dart' as api;
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:shipit_golden_app/core/networking/in_memory_auth_success_storage.dart';

/// Provides the single shared Serverpod [api.Client] and the auth session
/// manager that drives login, logout and JWT refresh for the whole app.
///
/// The default server URL can be overridden at build time with
/// `--dart-define=API_BASE_URL=http://host:port`.
class ServerpodClientProvider {
  static const _defaultServer = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  /// The canonical shared provider used by repositories and screens.
  ///
  /// Tests may replace this with a provider using in-memory storage and a
  /// hosted client.
  static ServerpodClientProvider shared = ServerpodClientProvider();

  final String serverUrl;
  final ClientAuthSuccessStorage storage;

  late final api.Client client;
  late final FlutterAuthSessionManager authSessionManager;

  ServerpodClientProvider({
    String? serverUrl,
    ClientAuthSuccessStorage? storage,
  }) : serverUrl = serverUrl ?? _defaultServer,
       storage = storage ?? _defaultStorage() {
    client = api.Client(this.serverUrl);
    authSessionManager = FlutterAuthSessionManager(storage: storage);
    client.authSessionManager = authSessionManager;
  }

  /// Sessions persist in the secure keychain on mobile/desktop. On web the
  /// keychain is unavailable, so sessions are kept in memory only.
  static ClientAuthSuccessStorage _defaultStorage() {
    if (kIsWeb) return InMemoryAuthSuccessStorage();
    return SecureClientAuthSuccessStorage();
  }
}
