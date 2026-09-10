import 'package:app_client/app_client.dart' as api;
import 'package:flutter/foundation.dart';
import 'package:serverpod_auth_core_flutter/serverpod_auth_core_flutter.dart';
import 'package:shipit_golden_app/core/config/flavor_config.dart';
import 'package:shipit_golden_app/core/networking/in_memory_auth_success_storage.dart';

/// Provides the single shared Serverpod [api.Client] and the auth session
/// manager that drives login, logout and JWT refresh for the whole app.
///
/// The server URL is resolved by [FlavorConfig.serverUrl] (compile-time
/// dart-define): each [AppFlavor] carries a default URL which can be
/// overridden with `--dart-define=API_BASE_URL=http://host:port`.
class ServerpodClientProvider {
  static final String _defaultServer = FlavorConfig.serverUrl;

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
  /// keychain is unavailable, so sessions are kept in memory only and are
  /// silently lost on a full page reload (see docs/architecture/frontend.md).
  static ClientAuthSuccessStorage _defaultStorage() {
    if (kIsWeb) return InMemoryAuthSuccessStorage();
    return SecureClientAuthSuccessStorage();
  }
}
