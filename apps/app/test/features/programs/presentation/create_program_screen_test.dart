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
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/create_program_screen.dart';

class MockProgramsRepository extends Mock implements ProgramsRepository {}

Program _program() {
  final now = DateTime.now();
  return Program(
    id: '42',
    name: 'Summer Camp',
    description: 'Annual summer camp',
    startDate: DateTime(now.year, now.month, 10),
    endDate: DateTime(now.year, now.month, 20),
    status: 'upcoming',
  );
}

void main() {
  late MockProgramsRepository repository;
  late ProgramCreateBloc bloc;

  setUp(() {
    repository = MockProgramsRepository();
    bloc = ProgramCreateBloc(repository: repository);
  });

  tearDown(() => bloc.close());

  Future<GoRouter> pumpCreate(
    WidgetTester tester, {
    String initialLocation = '/programs/create',
  }) async {
    final router = GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, _) => const Scaffold(body: Text('HOME')),
        ),
        GoRoute(
          path: '/programs/create',
          builder: (_, _) => BlocProvider<ProgramCreateBloc>.value(
            value: bloc,
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

  /// Pumps the router and pushes the create route, returning the push result.
  /// Opens the given date picker and selects [day] of the current month.
  Future<void> pickDay(
    WidgetTester tester, {
    required Key picker,
    required int day,
  }) async {
    await tester.tap(find.byKey(picker));
    await tester.pumpAndSettle();
    await tester.tap(find.text('$day'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
  }

  /// Scrolls the submit button into view and taps it, then drives the submit
  /// through the bloc: tap (event) → repo future → emit → listener side effects.
  /// Each extra pump flushes the next fake-async microtask hop, otherwise the
  /// post-await continuation stalls against the test binding.
  Future<void> submit(WidgetTester tester) async {
    final button = find.widgetWithText(AppButton, 'Create Program');
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pumpAndSettle();
  }

  testWidgets('renders the frozen form anatomy with no FAB or status control', (
    tester,
  ) async {
    await pumpCreate(tester);

    expect(
      find.descendant(
        of: find.byType(AppBar),
        matching: find.text('Create Program'),
      ),
      findsOneWidget, // AppBar title
    );
    expect(find.text('Program name'), findsOneWidget);
    expect(find.text('Description'), findsOneWidget);
    expect(find.text('Start date'), findsOneWidget);
    expect(find.text('End date'), findsOneWidget);
    expect(find.widgetWithText(AppButton, 'Create Program'), findsOneWidget);

    // PC-001/PC-002: no FAB on the surface, no status input in the form.
    expect(find.byType(FloatingActionButton), findsNothing);
    expect(find.byType(AppSelect), findsNothing);
  });

  testWidgets('initial focus lands on the name field', (tester) async {
    await pumpCreate(tester);

    final nameInput = tester.widget<TextField>(
      find.byKey(const Key('program_create_name')),
    );
    expect(nameInput.focusNode, isNotNull);
    expect(nameInput.focusNode!.hasFocus, isTrue);
  });

  testWidgets('a blank submit reports on the name field only', (tester) async {
    await pumpCreate(tester);

    await submit(tester);

    expect(find.text('Program name is required.'), findsOneWidget);
    expect(find.text('Select a start date.'), findsNothing);
    expect(find.text('Select an end date.'), findsNothing);
  });

  testWidgets('with a valid name and no dates both date fields report', (
    tester,
  ) async {
    await pumpCreate(tester);

    await tester.enterText(
      find.byKey(const Key('program_create_name')),
      'Summer Camp',
    );
    await submit(tester);

    expect(find.text('Program name is required.'), findsNothing);
    expect(find.text('Select a start date.'), findsOneWidget);
    expect(find.text('Select an end date.'), findsOneWidget);
  });

  testWidgets('equal dates fail the strict-after check on the end field', (
    tester,
  ) async {
    await pumpCreate(tester);

    await tester.enterText(
      find.byKey(const Key('program_create_name')),
      'Summer Camp',
    );
    await pickDay(tester, picker: const Key('program_create_start'), day: 15);
    await pickDay(tester, picker: const Key('program_create_end'), day: 15);
    await submit(tester);

    expect(find.text('End date must be after the start date.'), findsOneWidget);
    expect(find.text('Select a start date.'), findsNothing);
    expect(find.text('Select an end date.'), findsNothing);
  });

  testWidgets('an end date before the start date fails on the end field', (
    tester,
  ) async {
    await pumpCreate(tester);

    await tester.enterText(
      find.byKey(const Key('program_create_name')),
      'Summer Camp',
    );
    await pickDay(tester, picker: const Key('program_create_start'), day: 20);
    await pickDay(tester, picker: const Key('program_create_end'), day: 10);
    await submit(tester);

    expect(find.text('End date must be after the start date.'), findsOneWidget);
  });

  testWidgets('an end date with no start date asks for the start date first', (
    tester,
  ) async {
    await pumpCreate(tester);

    await tester.enterText(
      find.byKey(const Key('program_create_name')),
      'Summer Camp',
    );
    await pickDay(tester, picker: const Key('program_create_end'), day: 10);
    await submit(tester);

    expect(find.text('Select a start date first.'), findsOneWidget);
    expect(find.text('Select a start date.'), findsNothing);
  });

  testWidgets('a valid submit pops the route with true', (tester) async {
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
    ).thenAnswer((_) async => Result.success(_program()));

    final router = await pumpCreate(tester, initialLocation: '/home');
    final pushed = router.push<bool>('/programs/create');
    await tester.pumpAndSettle();

    // Drive the submission in the real async zone: the mocked repository's
    // roundtrip stalls under the widget binding's fake zone, so the event is
    // delivered to the bloc from `runAsync`. The listener must pop with `true`
    // so the programs list refreshes on return (AC-QA-003).
    await tester.runAsync(() async {
      bloc.add(
        ProgramCreateSubmitted(
          name: 'Summer Camp',
          description: '',
          startDate: startDate,
          endDate: endDate,
        ),
      );
      // Give the bloc a few real-async turns to run the handler to completion.
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();

    expect(await pushed, isTrue);
    expect(find.text('HOME'), findsOneWidget);
  });

  testWidgets('a failed submit keeps the form and shows a dismissible alert', (
    tester,
  ) async {
    when(
      () => repository.createProgram(
        name: any(named: 'name'),
        description: any(named: 'description'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer(
      (_) async => Result.failure(AppFailure.network(message: 'offline')),
    );

    await pumpCreate(tester);
    final now = DateTime.now();

    await tester.enterText(
      find.byKey(const Key('program_create_name')),
      'Summer Camp',
    );
    await tester.enterText(
      find.byKey(const Key('program_create_description')),
      'Annual summer camp',
    );
    await tester.runAsync(() async {
      bloc.add(
        ProgramCreateSubmitted(
          name: 'Summer Camp',
          description: 'Annual summer camp',
          startDate: DateTime(now.year, now.month, 10),
          endDate: DateTime(now.year, now.month, 20),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();

    // Settled failure: form content survives, alert renders above the fields.
    expect(find.text('Summer Camp'), findsOneWidget);
    expect(find.text('Annual summer camp'), findsOneWidget);
    expect(find.byType(AppInlineAlert), findsOneWidget);
    expect(find.text('Could not create program'), findsOneWidget);
    expect(find.text('Network error: offline'), findsOneWidget);
    expect(find.text('Retry'), findsNothing);

    // The alert is dismissible and the form stays editable.
    await tester.tap(find.byKey(AppInlineAlert.dismissKey));
    // Let the dismiss handler complete its last hop in the real async zone,
    // then re-render; the fake-zone frame loop misses the rebuild otherwise.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 20)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(AppInlineAlert), findsNothing);
    expect(find.text('Summer Camp'), findsOneWidget);
  });

  testWidgets('a failed submit never pops the route', (tester) async {
    when(
      () => repository.createProgram(
        name: any(named: 'name'),
        description: any(named: 'description'),
        startDate: any(named: 'startDate'),
        endDate: any(named: 'endDate'),
      ),
    ).thenAnswer(
      (_) async => Result.failure(AppFailure.server(message: 'boom')),
    );

    final router = await pumpCreate(tester, initialLocation: '/home');
    router.push<bool>('/programs/create');
    await tester.pumpAndSettle();
    final now = DateTime.now();

    await tester.enterText(
      find.byKey(const Key('program_create_name')),
      'Summer Camp',
    );
    await tester.runAsync(() async {
      bloc.add(
        ProgramCreateSubmitted(
          name: 'Summer Camp',
          description: '',
          startDate: DateTime(now.year, now.month, 10),
          endDate: DateTime(now.year, now.month, 20),
        ),
      );
      for (var i = 0; i < 10; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 10));
      }
    });
    await tester.pumpAndSettle();

    expect(find.byType(AppInlineAlert), findsOneWidget);
    expect(find.text('HOME'), findsNothing);
  });

  testWidgets(
    'an in-flight submit swaps the button to loading and announces it',
    (tester) async {
      final completer = Completer<Result<Program>>();
      when(
        () => repository.createProgram(
          name: any(named: 'name'),
          description: any(named: 'description'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) => completer.future);

      final now = DateTime.now();
      final router = await pumpCreate(tester, initialLocation: '/home');
      router.push<bool>('/programs/create');
      await tester.pumpAndSettle();

      // Keep the roundtrip pending in the real async zone so the button can be
      // observed mid-flight; the completer is resolved once asserted.
      await tester.runAsync(() async {
        bloc.add(
          ProgramCreateSubmitted(
            name: 'Summer Camp',
            description: '',
            startDate: DateTime(now.year, now.month, 10),
            endDate: DateTime(now.year, now.month, 20),
          ),
        );
        await Future<void>.delayed(const Duration(milliseconds: 10));
      });
      // Fixed pumps while the submit is in flight: the loading spinner animates
      // indefinitely, so `pumpAndSettle` would never return here.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final button = tester.widget<AppButton>(find.byType(AppButton));
      expect(button.state, AppButtonState.loading);
      expect(button.onPressed, isNull);
      expect(find.bySemanticsLabel('Create Program, loading'), findsOneWidget);
      // The only spinner is the one inside the submit button.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(AppButton),
          matching: find.byType(CircularProgressIndicator),
        ),
        findsOneWidget,
      );

      await tester.runAsync(() async {
        completer.complete(Result.success(_program()));
        for (var i = 0; i < 10; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
      });
      await tester.pumpAndSettle();
      expect(find.byType(AppInlineAlert), findsNothing);
    },
  );
}
