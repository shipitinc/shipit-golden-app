import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/app/app.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';
import 'package:shipit_golden_app/features/authentication/data/auth_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

final _fakeAuth = AuthSuccess(
  token: 'new-token',
  authStrategy: 'jwt',
  authUserId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
  scopeNames: const {},
);

void main() {
  testWidgets(
    'unauthenticated user landing on a protected route is redirected to /login',
    (tester) async {
      final repository = _MockAuthRepository();
      when(() => repository.restoreSession()).thenAnswer((_) async {});
      when(() => repository.isAuthenticated).thenReturn(false);

      final bloc = AuthenticationBloc(authRepository: repository);
      addTearDown(bloc.close);

      await tester.pumpWidget(ShipItGoldenApp(authBloc: bloc));
      await tester.pumpAndSettle();
      bloc.add(const AuthenticationEvent.started());
      await tester.pumpAndSettle();

      // Redirect guard lands on /login with the shipit_ui auth card.
      expect(find.text(FlavorConfig.appName), findsOneWidget);
      expect(find.text('Sign In'), findsOneWidget);
      expect(find.byType(AppTextField), findsNWidgets(2));
    },
  );

  testWidgets('failed login surfaces a safe, human-readable AppInlineAlert', (
    tester,
  ) async {
    final repository = _MockAuthRepository();
    when(() => repository.restoreSession()).thenAnswer((_) async {});
    when(() => repository.isAuthenticated).thenReturn(false);
    when(() => repository.login(any(), any())).thenAnswer(
      (_) async => Result<AuthSuccess>.failure(
        AppFailure.auth(message: 'Invalid credentials'),
      ),
    );

    final bloc = AuthenticationBloc(authRepository: repository);
    addTearDown(bloc.close);

    await tester.pumpWidget(ShipItGoldenApp(authBloc: bloc));
    await tester.pumpAndSettle();
    bloc.add(const AuthenticationEvent.started());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(AppTextField, 'Email'),
      'someone@example.com',
    );
    await tester.enterText(
      find.widgetWithText(AppTextField, 'Password'),
      'wrong-password',
    );
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    expect(find.byType(AppInlineAlert), findsOneWidget);
    expect(
      find.text('Authentication required: Invalid credentials'),
      findsOneWidget,
    );
  });

  testWidgets(
    'field-level validation errors render beneath the fields on submit',
    (tester) async {
      final repository = _MockAuthRepository();
      when(() => repository.restoreSession()).thenAnswer((_) async {});
      when(() => repository.isAuthenticated).thenReturn(false);

      final bloc = AuthenticationBloc(authRepository: repository);
      addTearDown(bloc.close);

      await tester.pumpWidget(ShipItGoldenApp(authBloc: bloc));
      await tester.pumpAndSettle();
      bloc.add(const AuthenticationEvent.started());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(AppTextField, 'Email'),
        'not-an-email',
      );
      await tester.enterText(
        find.widgetWithText(AppTextField, 'Password'),
        'sh',
      );
      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      // GAP-010: validators now run through the Form and each field shows its
      // own actionable message instead of the old hardcoded generic string.
      expect(find.text('Enter a valid email'), findsOneWidget);
      expect(
        find.text('Password must be at least 8 characters'),
        findsOneWidget,
      );
      expect(find.text('Error: Please check this field'), findsNothing);
      expect(find.byType(AppInlineAlert), findsNothing);
    },
  );

  testWidgets('successful login navigates away from /login', (tester) async {
    final repository = _MockAuthRepository();
    when(() => repository.restoreSession()).thenAnswer((_) async {});
    when(() => repository.isAuthenticated).thenReturn(false);
    when(
      () => repository.login(any(), any()),
    ).thenAnswer((_) async => Result<AuthSuccess>.success(_fakeAuth));

    final bloc = AuthenticationBloc(authRepository: repository);
    addTearDown(bloc.close);

    await tester.pumpWidget(ShipItGoldenApp(authBloc: bloc));
    await tester.pumpAndSettle();
    bloc.add(const AuthenticationEvent.started());
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(AppTextField, 'Email'),
      'someone@example.com',
    );
    await tester.enterText(
      find.widgetWithText(AppTextField, 'Password'),
      'correct-password',
    );
    await tester.tap(find.text('Sign In'));
    await tester.pumpAndSettle();

    // Navigated away from /login; no login-level failure alert is shown.
    expect(find.text('Household'), findsOneWidget);
    expect(find.text('Sign In Failed'), findsNothing);
  });

  testWidgets('authenticated user can sign out and returns to /login', (
    tester,
  ) async {
    final repository = _MockAuthRepository();
    when(() => repository.restoreSession()).thenAnswer((_) async {});
    when(() => repository.isAuthenticated).thenReturn(true);
    when(() => repository.authInfo).thenReturn(_fakeAuth);
    when(() => repository.logout()).thenAnswer((_) async {});

    final bloc = AuthenticationBloc(authRepository: repository);
    addTearDown(bloc.close);

    await tester.pumpWidget(ShipItGoldenApp(authBloc: bloc));
    await tester.pumpAndSettle();
    bloc.add(const AuthenticationEvent.started());
    await tester.pumpAndSettle();

    // An authenticated session lands on the household screen with a sign-out.
    expect(find.text('Household'), findsOneWidget);
    expect(find.byTooltip('Sign out'), findsOneWidget);

    await tester.tap(find.byTooltip('Sign out'));
    await tester.pumpAndSettle();

    verify(() => repository.logout()).called(1);
    expect(find.text('Sign In'), findsOneWidget);
  });
}
