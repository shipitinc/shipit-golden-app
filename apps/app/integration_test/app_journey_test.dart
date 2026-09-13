import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/app/app.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';

/// End-to-end journey against a live server.
///
/// Requires `docker compose up` + `melos run dev:server` + a running Flutter
/// app. Run from repository root with:
///
///     melos run test:integration
///
/// In this environment the golden dev server runs on :8099 with runtime env
/// overrides (see `docs/qa/pending-actions.md` #2), so the journey must point
/// `API_BASE_URL` at the live server, e.g.:
///
///     fvm flutter test integration_test --dart-define=FLAVOR=development \
///       --dart-define=API_BASE_URL=http://localhost:8099 \
///       --dart-define=E2E_VERIFICATION_CODE=<code logged by the dev server>
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // The development server prints each verification code to its console
  // (`[dev] Email verification code for <email>: <code>`); the operator reads
  // it once and passes it via `--dart-define=E2E_VERIFICATION_CODE=<code>`.
  // This keeps the journey fully deterministic against a real Serverpod +
  // PostgreSQL (never against a mock).
  const e2eVerificationCode = String.fromEnvironment('E2E_VERIFICATION_CODE');
  if (e2eVerificationCode.isEmpty) {
    throw StateError(
      'E2E_VERIFICATION_CODE dart-define is required. Start the dev server, '
      'request the verification email, and pass the logged code via '
      '--dart-define=E2E_VERIFICATION_CODE=<code>.',
    );
  }

  testWidgets('unauthenticated user is redirected to /login', (tester) async {
    final authBloc = AuthenticationBloc();
    await tester.pumpWidget(ShipItGoldenApp(authBloc: authBloc));
    await tester.pumpAndSettle();

    expect(find.text(FlavorConfig.appName), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(
      find.byType(AppTextField),
      findsNWidgets(2), // email + password
    );
    await authBloc.close();
  });

  testWidgets('wrong password shows a safe failure alert (server-backed)', (
    tester,
  ) async {
    final authBloc = AuthenticationBloc();
    await tester.pumpWidget(ShipItGoldenApp(authBloc: authBloc));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(AppTextField, 'Email'),
      'integration_${DateTime.now().millisecondsSinceEpoch}@example.com',
    );
    await tester.enterText(
      find.widgetWithText(AppTextField, 'Password'),
      'definitely-wrong-password',
    );
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 30),
    );

    // The server rejects the bad credentials and the app surfaces a safe,
    // human-readable message via AppInlineAlert (never raw exception text).
    expect(find.byType(AppInlineAlert), findsOneWidget);
    await authBloc.close();
  });

  // The real Serverpod + PostgreSQL journey (frozen QA Contract, End-to-End
  // Tests): authenticated navigate /programs → reach the create entry point →
  // fill and submit the form → return to a list containing the created program
  // → open the card and observe the joined state.
  //
  // Registration is driven through the UI with a fresh email so each run
  // starts from deterministic, unseeded state that persists through the REAL
  // Serverpod + PostgreSQL boundary.
  testWidgets('create a program end-to-end against the live server', (
    tester,
  ) async {
    final authBloc = AuthenticationBloc();
    await tester.pumpWidget(ShipItGoldenApp(authBloc: authBloc));
    await tester.pumpAndSettle();

    final email =
        'e2e_${DateTime.now().millisecondsSinceEpoch}@lets.shipit.app';

    // --- authenticate: register a fresh account ---
    await tester.enterText(find.widgetWithText(AppTextField, 'Email'), email);
    await tester.tap(find.text('Request Verification Code'));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 30),
    );
    expect(find.text('Enter the code sent to'), findsOneWidget);
    expect(
      find.widgetWithText(AppTextField, 'Verification Code'),
      findsOneWidget,
    );
    await tester.enterText(
      find.widgetWithText(AppTextField, 'Verification Code'),
      e2eVerificationCode,
    );
    await tester.enterText(
      find.widgetWithText(AppTextField, 'Password'),
      'ShipItTest#123',
    );
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 30),
    );

    // --- reach the authorized creation entry point ---
    expect(find.text('Programs'), findsOneWidget);
    expect(find.byKey(const Key('programs_create_action')), findsOneWidget);

    // --- fill and submit the create form ---
    await tester.tap(find.byKey(const Key('programs_create_action')));
    await tester.pumpAndSettle();
    expect(find.text('Create Program'), findsWidgets);

    final now = DateTime.now();
    final name = 'E2E Program ${now.millisecondsSinceEpoch}';
    final description = 'Created by the live-server E2E journey';
    await tester.enterText(
      find.widgetWithText(AppTextField, 'Program name'),
      name,
    );
    await tester.enterText(
      find.widgetWithText(AppTextField, 'Description'),
      description,
    );
    // Start date = tomorrow, end date = tomorrow + 5 (calendar entry).
    await tester.tap(find.text('Start date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('End date'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(AppButton, 'Create Program'));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 30),
    );

    // --- created program appears in the list ---
    expect(find.text(name), findsOneWidget);

    // --- open the card and observe the joined state ---
    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle(
      const Duration(milliseconds: 100),
      EnginePhase.sendSemanticsUpdate,
      const Duration(seconds: 30),
    );
    expect(find.text('Program Details'), findsOneWidget);
    expect(find.text('JOINED'), findsOneWidget);
    expect(find.text('Cancel Membership'), findsOneWidget);

    await authBloc.close();
  });
}
