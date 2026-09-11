import 'package:shipit_golden_app/core/errors/app_failure.dart';

/// Announces mid-session auth-expiry so the app shell can end the session.
///
/// Serverpod rejects an expired/invalidated JWT with
/// `ServerpodClientUnauthorized`, which [mapAppFailure] turns into an
/// [AuthFailure] whose code is `session_expired`. That failure is user-safe for
/// whichever feature screen surfaced the call, but the root [AuthenticationBloc]
/// — the authority that flips the whole app back to the login screen — does not
/// observe feature-BLoC results. This notifier is the bridge between the two.
///
/// This is a UX convenience, not a security enforcement point: the server is
/// authoritative and has already refused the request.
///
/// Dependency note: an instance (not a section-static class), so tests and a
/// future DI container can supply their own via [mapAppFailure]'s `notifier`
/// parameter. Production uses [shared], mirroring the
/// `ServerpodClientProvider.shared` convention.
class SessionExpiredNotifier {
  /// The canonical instance used by [mapAppFailure] and the app shell by
  /// default.
  static final SessionExpiredNotifier shared = SessionExpiredNotifier();

  final Set<void Function()> _listeners = {};

  /// Registers [listener] so it fires whenever a mid-session auth-expiry is
  /// observed. Callers must pair this with [remove].
  void add(void Function() listener) => _listeners.add(listener);

  /// Unregisters a listener previously registered with [add].
  void remove(void Function() listener) => _listeners.remove(listener);

  /// Fires registered listeners when [failure] represents an expired session.
  ///
  /// Otherwise a no-op, so the translator can announce centrally without
  /// affecting screens that surface non-auth failures.
  void announceIfExpired(AppFailure failure) {
    if (failure is! AuthFailure || failure.code != 'session_expired') return;
    for (final listener in List<void Function()>.of(_listeners)) {
      listener();
    }
  }
}
