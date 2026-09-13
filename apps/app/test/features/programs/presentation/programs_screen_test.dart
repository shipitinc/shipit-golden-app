import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shipit_ui/shipit_ui.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_event.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/create_program_screen.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/programs_screen.dart';

class MockProgramsRepository extends Mock implements ProgramsRepository {}

void main() {
  late MockProgramsRepository repository;
  late ProgramsBloc programsBloc;
  late ProgramCreateBloc createBloc;

  Program sampleProgram() {
    final now = DateTime.now();
    return Program(
      id: '1',
      name: 'Summer Camp',
      description: 'Annual summer camp',
      startDate: DateTime(now.year, now.month, 10),
      endDate: DateTime(now.year, now.month, 20),
      status: 'upcoming',
    );
  }

  setUp(() {
    repository = MockProgramsRepository();
    programsBloc = ProgramsBloc(repository: repository);
    createBloc = ProgramCreateBloc(repository: repository);
  });

  tearDown(() {
    programsBloc.close();
    createBloc.close();
  });

  /// Routed harness mirroring the app's programs branch with injected blocs.
  Future<GoRouter> pumpPrograms(WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/programs',
      routes: [
        GoRoute(
          path: '/programs',
          name: 'programs',
          builder: (_, _) => BlocProvider<ProgramsBloc>.value(
            value: programsBloc,
            child: const ProgramsView(),
          ),
        ),
        GoRoute(
          path: '/programs/create',
          name: 'program-create',
          builder: (_, _) => BlocProvider<ProgramCreateBloc>.value(
            value: createBloc,
            child: const ProgramCreateView(),
          ),
        ),
      ],
    );
    await tester.pumpWidget(
      MaterialApp.router(theme: shipitLightTheme(), routerConfig: router),
    );
    await tester.pumpAndSettle();
    return router;
  }

  /// Loads the programs list.
  ///
  /// The bloc roundtrip must run in the real async zone: an awaited mocktail
  /// answer never completes inside the widget binding's fake zone, which
  /// leaves the loading shimmer animating forever.
  Future<void> loadPrograms(WidgetTester tester) async {
    await tester.runAsync(() async {
      programsBloc.add(const ProgramsEvent.started());
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();
  }

  testWidgets(
    'the create action is the first app-bar action, no FAB on the surface',
    (tester) async {
      when(
        () => repository.getPrograms(),
      ).thenAnswer((_) async => Result.success([sampleProgram()]));
      await pumpPrograms(tester);
      await loadPrograms(tester);

      expect(find.byKey(const Key('programs_create_action')), findsOneWidget);
      expect(find.byTooltip('Refresh'), findsOneWidget);
      expect(find.byTooltip('Sign out'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);

      final createX = tester
          .getTopLeft(find.byKey(const Key('programs_create_action')))
          .dx;
      final refreshX = tester.getTopLeft(find.byTooltip('Refresh')).dx;
      final signOutX = tester.getTopLeft(find.byTooltip('Sign out')).dx;
      expect(createX, lessThan(refreshX));
      expect(refreshX, lessThan(signOutX));
    },
  );

  testWidgets('the empty state renders the create CTA with the final copy', (
    tester,
  ) async {
    when(
      () => repository.getPrograms(),
    ).thenAnswer((_) async => Result.success(<Program>[]));
    await pumpPrograms(tester);
    await loadPrograms(tester);

    expect(find.byType(AppEmptyState), findsOneWidget);
    expect(find.text('Programs you create will appear here.'), findsOneWidget);
    expect(find.text('Create program'), findsOneWidget);
    expect(find.byKey(const Key('programs_empty_create')), findsOneWidget);
  });

  testWidgets('the app-bar action pushes the create flow', (tester) async {
    when(
      () => repository.getPrograms(),
    ).thenAnswer((_) async => Result.success([sampleProgram()]));
    await pumpPrograms(tester);
    await loadPrograms(tester);

    await tester.tap(find.byKey(const Key('programs_create_action')));
    await tester.pumpAndSettle();

    expect(find.text('Create Program'), findsWidgets); // AppBar + submit CTA
    expect(find.text('Program name'), findsOneWidget);
  });

  testWidgets('the empty-state CTA pushes the create flow', (tester) async {
    when(
      () => repository.getPrograms(),
    ).thenAnswer((_) async => Result.success(<Program>[]));
    await pumpPrograms(tester);
    await loadPrograms(tester);

    await tester.tap(find.text('Create program'));
    await tester.pumpAndSettle();

    expect(find.text('Program name'), findsOneWidget);
  });

  testWidgets('a created program pops with true and refreshes the list', (
    tester,
  ) async {
    var getCalls = 0;
    final firstLoad = Completer<Result<List<Program>>>();
    final refreshLoad = Completer<Result<List<Program>>>();
    when(() => repository.getPrograms()).thenAnswer((_) {
      getCalls++;
      if (getCalls == 1) return firstLoad.future;
      return refreshLoad.future;
    });
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 10);
    final endDate = DateTime(now.year, now.month, 20);
    when(
      () => repository.createProgram(
        name: 'Summer Camp',
        description: '',
        startDate: startDate,
        endDate: endDate,
      ),
    ).thenAnswer((_) async => Result.success(sampleProgram()));

    await pumpPrograms(tester);

    // The reload kicked off at pump time passes through the list's loading
    // branch (AC-QA-008): `AppSkeleton.card` placeholders and no spinner. The
    // first fetch is gated so the loading state can be pumped deterministically.
    await tester.runAsync(() async {
      programsBloc.add(const ProgramsEvent.started());
      await Future<void>.delayed(const Duration(milliseconds: 10));
    });
    await tester.pump();
    expect(find.byType(AppSkeleton), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(AppEmptyState), findsNothing);

    await tester.runAsync(() async {
      firstLoad.complete(Result.success(<Program>[]));
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();
    expect(find.byType(AppEmptyState), findsOneWidget);

    // Enter the flow through the empty-state CTA.
    await tester.tap(find.text('Create program'));
    await tester.pumpAndSettle();
    expect(find.text('Program name'), findsOneWidget);

    // Complete the submission out-of-band: the completed state pops with
    // `true`, which must kick off a list refresh.
    await tester.runAsync(() async {
      createBloc.add(
        ProgramCreateSubmitted(
          name: 'Summer Camp',
          description: '',
          startDate: startDate,
          endDate: endDate,
        ),
      );
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    // The pop's future continuation crosses the fake/real async boundary: give
    // the real event loop a turn so the refresh's `loading` emission and its
    // `AppSkeleton` render land. `pumpAndSettle` cannot be used while the
    // skeleton is on screen — its shimmer repeats indefinitely.
    await tester.runAsync(() async {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    });
    await tester.pump();

    // The refresh is now in flight (its fetch is still gated): it is a full
    // reload, so the list emits `ProgramsState.loading()` → `AppSkeleton.card`
    // placeholders and no spinner (AC-QA-008). No content stays rendered.
    expect(find.byType(AppSkeleton), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(AppEmptyState), findsNothing);

    // Flush the refresh roundtrip (a second awaited getPrograms).
    await tester.runAsync(() async {
      refreshLoad.complete(Result.success([sampleProgram()]));
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyState), findsNothing);
    expect(find.text('Summer Camp'), findsOneWidget);
    verify(
      () => repository.createProgram(
        name: 'Summer Camp',
        description: '',
        startDate: startDate,
        endDate: endDate,
      ),
    ).called(1);
    expect(getCalls, 2);
  });

  testWidgets('cancelling the flow pops without a refresh', (tester) async {
    when(
      () => repository.getPrograms(),
    ).thenAnswer((_) async => Result.success(<Program>[]));
    await pumpPrograms(tester);
    await loadPrograms(tester);

    await tester.tap(find.text('Create program'));
    await tester.pumpAndSettle();
    await tester.pageBack();
    await tester.pumpAndSettle();

    expect(find.byType(AppEmptyState), findsOneWidget);
    verify(() => repository.getPrograms()).called(1);
  });
}
