import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/app/routing/app_router.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';
import 'package:shipit_golden_app/features/authentication/data/auth_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

final _fakeAuth = AuthSuccess(
  token: 'create-route-test-token',
  authStrategy: 'jwt',
  authUserId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
  scopeNames: const {},
);

void main() {
  late _MockAuthRepository repository;

  setUp(() {
    repository = _MockAuthRepository();
  });

  test(
    'program-create is registered in the programs branch before the id route',
    () {
      when(() => repository.restoreSession()).thenAnswer((_) async {});
      final bloc = AuthenticationBloc(authRepository: repository);
      addTearDown(bloc.close);

      final appRouter = AppRouter(bloc);
      addTearDown(appRouter.dispose);

      final shell = appRouter.router.configuration.routes
          .whereType<StatefulShellRoute>()
          .single;
      final programsBranch = shell.branches.firstWhere(
        (branch) => branch.routes.whereType<GoRoute>().any(
          (route) => route.path == '/programs',
        ),
      );

      final routePaths = programsBranch.routes
          .whereType<GoRoute>()
          .map((route) => route.path)
          .toList();
      expect(
        routePaths.indexOf('/programs/create'),
        lessThan(routePaths.indexOf('/programs/:id')),
        reason: 'the create route must be declared before /programs/:id',
      );

      final createRoute = programsBranch.routes.whereType<GoRoute>().firstWhere(
        (route) => route.name == 'program-create',
      );
      expect(createRoute.path, '/programs/create');
    },
  );

  testWidgets('navigating to create while unauthenticated lands on login', (
    tester,
  ) async {
    when(() => repository.restoreSession()).thenAnswer((_) async {});
    when(() => repository.isAuthenticated).thenReturn(false);

    final bloc = AuthenticationBloc(authRepository: repository);
    addTearDown(bloc.close);

    final appRouter = AppRouter(bloc);
    addTearDown(appRouter.dispose);

    await tester.pumpWidget(
      MaterialApp.router(
        theme: shipitLightTheme(),
        routerConfig: appRouter.router,
      ),
    );
    await tester.pumpAndSettle();

    appRouter.router.go('/programs/create');
    await tester.pumpAndSettle();

    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Program name'), findsNothing);
  });

  testWidgets(
    'navigating to create when authenticated shows the create screen',
    (tester) async {
      when(() => repository.restoreSession()).thenAnswer((_) async {});
      when(() => repository.isAuthenticated).thenReturn(true);
      when(() => repository.authInfo).thenReturn(_fakeAuth);

      final bloc = AuthenticationBloc(authRepository: repository);
      addTearDown(bloc.close);

      final appRouter = AppRouter(bloc);
      addTearDown(appRouter.dispose);

      await tester.pumpWidget(
        MaterialApp.router(
          theme: shipitLightTheme(),
          routerConfig: appRouter.router,
        ),
      );
      await tester.pumpAndSettle();
      bloc.add(const AuthenticationEvent.started());
      await tester.pumpAndSettle();

      appRouter.router.go('/programs/create');
      await tester.pumpAndSettle();

      expect(find.text('Create Program'), findsWidgets);
    },
  );
}
