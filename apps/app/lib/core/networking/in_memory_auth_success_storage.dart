import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

/// A non-persisting [ClientAuthSuccessStorage] backed by a single in-memory
/// slot.
///
/// Used as the default session storage on web (where the secure keychain is not
/// available) and in tests to avoid platform channels.
class InMemoryAuthSuccessStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _data;

  @override
  Future<void> set(AuthSuccess? data) async {
    _data = data;
  }

  @override
  Future<AuthSuccess?> get() async => _data;
}
