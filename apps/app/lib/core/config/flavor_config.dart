import 'package:shipit_golden_app/core/config/app_flavor.dart';

/// Compile-time build configuration derived from the active [AppFlavor].
///
/// The active flavor is read from the `FLAVOR` dart-define passed at build
/// time (`--dart-define=FLAVOR=development`). When absent the app defaults to
/// the [AppFlavor.development] configuration so a plain `flutter run` or
/// `melos run dev:app` works out of the box.
///
/// Per-flavor constants (`appName`, `serverUrl`) are compile-time `String`s`
/// backed by `String.fromEnvironment`, keeping them tree-shakeable and
/// compatible with both AOT (mobile) and JIT (web) builds.
///
/// ## Standard
///
/// Every shipit-style app MUST define its flavors here. The three standard
/// environments are:
///
/// | Flavor         | Android appId                        | iOS bundleId                           | Purpose                        |
/// |----------------|--------------------------------------|----------------------------------------|--------------------------------|
/// | `development`  | `io.letsshipit.golden`               | `io.letsshipit.golden`                 | Local development              |
/// | `qa`           | `io.letsshipit.golden.qa`            | `io.letsshipit.golden.qa`              | Internal QA (Teamhub listing)  |
/// | `production`   | `io.letsshipit.golden.production`    | `io.letsshipit.golden.production`      | End-user (Google Play / App Store) |
///
/// App names are prefixed for unambiguous identification:
///   - Development → `[Dev] ShipIt Golden App`
///   - QA          → `[QA] ShipIt Golden App`
///   - Production  → `ShipIt Golden App`
class FlavorConfig {
  FlavorConfig._();

  /// The active [AppFlavor], determined once at startup from the `FLAVOR`
  /// dart-define.
  static final AppFlavor current = _resolveFlavor();

  /// Human-readable, environment-tagged app name (e.g. `[Dev] ShipIt Golden
  /// App`).  Used as the browser tab title and the `MaterialApp.title`.
  static String get appName => current._appName;

  /// Server URL for the active environment.
  ///
  /// Development defaults to `http://localhost:8080` (local Serverpod).
  /// QA and production default to `http://localhost:8080` and MUST be
  /// overridden via `--dart-define=API_BASE_URL=...` at build time.
  ///
  /// An explicit `API_BASE_URL` dart-define always takes precedence over
  /// the flavor default.
  static String get serverUrl => _serverUrl;

  // ---------------------------------------------------------------------------
  // Internals
  // ---------------------------------------------------------------------------

  static final String _serverUrl = _resolveServerUrl();
}

// ---------------------------------------------------------------------------
// Private resolution helpers
// ---------------------------------------------------------------------------

AppFlavor _resolveFlavor() {
  const value = String.fromEnvironment('FLAVOR');
  return AppFlavor.values.asNameMap()[value] ?? AppFlavor.development;
}

String _resolveServerUrl() {
  // Explicit override always wins.
  const override = String.fromEnvironment('API_BASE_URL');
  if (override.isNotEmpty) return override;

  final flavor = _resolveFlavor();
  // Per-flavor defaults.
  final url = switch (flavor) {
    AppFlavor.development => 'http://localhost:8080',
    AppFlavor.qa => 'http://localhost:8080',
    AppFlavor.production => 'http://localhost:8080',
  };
  assert(
    !url.contains('localhost') || flavor == AppFlavor.development,
    'QA/production defaults to a localhost API URL; build with '
    '--dart-define=API_BASE_URL=<real-host> for a non-development flavor.',
  );
  return url;
}

extension _AppFlavorX on AppFlavor {
  String get _appName => switch (this) {
    AppFlavor.development => '[Dev] ShipIt Golden App',
    AppFlavor.qa => '[QA] ShipIt Golden App',
    AppFlavor.production => 'ShipIt Golden App',
  };
}
