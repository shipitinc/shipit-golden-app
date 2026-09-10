import 'package:serverpod/serverpod.dart';

/// Returns a `configOverride` that binds the API server to an OS-assigned
/// ephemeral port instead of the fixed port from `config/test.yaml`.
///
/// Every `withServerpod` group boots its own Serverpod instance, and the shared
/// fixed port causes flaky "address already in use" failures whenever one
/// server has not fully released the port before the next binds it (which can
/// happen within a file when groups run back-to-back and across files when
/// suites run in parallel). A port of `0` makes the OS pick a free port, so
/// instances never collide and the suite stays deterministic.
ServerpodConfig Function(ServerpodConfig) useEphemeralApiPort() {
  return (config) => config.copyWith(
    apiServer: ServerConfig(
      port: 0,
      publicHost: config.apiServer.publicHost,
      publicPort: config.apiServer.publicPort,
      publicScheme: config.apiServer.publicScheme,
    ),
  );
}
