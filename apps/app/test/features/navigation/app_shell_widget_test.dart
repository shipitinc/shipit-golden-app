import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/app/app.dart';
import 'package:shipit_golden_app/app/shell/app_shell.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';
import 'package:shipit_golden_app/features/authentication/data/auth_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

final _fakeAuth = AuthSuccess(
  token: 'shell-test-token',
  authStrategy: 'jwt',
  authUserId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
  scopeNames: const {},
);

/// Starts the full app in an authenticated session so the router lands on the
/// shell's household branch.
Future<AuthenticationBloc> _startAuthenticated(WidgetTester tester) async {
  final repository = _MockAuthRepository();
  when(() => repository.restoreSession()).thenAnswer((_) async {});
  when(() => repository.isAuthenticated).thenReturn(true);
  when(() => repository.authInfo).thenReturn(_fakeAuth);

  final bloc = AuthenticationBloc(authRepository: repository);
  addTearDown(bloc.close);

  await tester.pumpWidget(ShipItGoldenApp(authBloc: bloc));
  await tester.pumpAndSettle();
  bloc.add(const AuthenticationEvent.started());
  await tester.pumpAndSettle();
  return bloc;
}

void main() {
  testWidgets(
    'an authenticated session lands on the Household tab inside the shell',
    (tester) async {
      await _startAuthenticated(tester);

      expect(find.byType(AppShell), findsOneWidget);
      expect(find.byType(AppNavigationRail), findsOneWidget);
      // Household branch is active (app-bar title); Programs is not built on
      // stage because the IndexedStack keeps the other branch offstage.
      expect(find.text('Household'), findsOneWidget);
      expect(find.text('Programs'), findsNothing);
    },
  );

  testWidgets('the rail switches between Household and Programs and back', (
    tester,
  ) async {
    await _startAuthenticated(tester);

    // Default test viewport (800x600) is below the desktop breakpoint, so the
    // rail is collapsed to icon-only destinations labelled by tooltip.
    await tester.tap(find.byTooltip('Programs'));
    await tester.pumpAndSettle();

    expect(find.text('Programs'), findsOneWidget);
    expect(find.text('Household'), findsNothing);

    await tester.tap(find.byTooltip('Household'));
    await tester.pumpAndSettle();

    expect(find.text('Household'), findsOneWidget);
    expect(find.text('Programs'), findsNothing);
  });

  testWidgets('the rail extends with text labels at desktop width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await _startAuthenticated(tester);

    // Rail label + household app-bar title; Programs stays offstage.
    expect(find.text('Household'), findsNWidgets(2));
    expect(find.text('Programs'), findsOneWidget);

    // Re-selecting the active destination stays on the branch (no stacked
    // duplicate pages) and the shell remains intact.
    await tester.tap(find.byKey(const Key('nav-household')));
    await tester.pumpAndSettle();
    expect(find.byType(AppShell), findsOneWidget);
    expect(find.text('Household'), findsNWidgets(2));
    expect(find.text('Programs'), findsOneWidget);
  });
}
