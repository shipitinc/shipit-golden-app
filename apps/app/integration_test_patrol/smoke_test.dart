/// Patrol smoke skeleton for the ShipIt Golden App.
///
/// This file demonstrates the Patrol test structure for future E2E flows.
/// It is NOT wired into the regular `test:integration` pipeline
/// (`integration_test/` — see AGENTS.md and `product.yaml`). Running
/// these requires Patrol CLI setup and a target device; they cannot run
/// as `flutter test` with the default harness.
///
/// To run Patrol tests (on an available device):
///
///     patrol build android --target test/integration_test_patrol/smoke_test.dart
///     patrol test android
///
/// Or:
///
///     patrol run --target test/integration_test_patrol/smoke_test.dart
///
/// Per `product.yaml` (`qa.patrol: false`), these are currently disabled
/// in the standard QA pipeline pending device/CI integration.
void main() {
  // future: patrolTest('login and reach home screen', ...)
  //
  // The full E2E registration → code entry → login → household view
  // journey will use Patrol's native actions to:
  //   1. navigate to /login,
  //   2. complete the registration form (dev code via server console log),
  //   3. sign in,
  //   4. assert the protected screen renders.
  //
  // This file intentionally contains no executable tests yet;
  // it establishes the structure for future Patrol integration.
}
