import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/app/app.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';

/// End-to-end journey against a live server.
///
/// Requires `docker compose up` + `melos run dev:server` (localhost:8080).
/// Run from repository root with:
///
///     melos run test:integration
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

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
}
