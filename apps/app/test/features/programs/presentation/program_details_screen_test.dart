import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_event.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';
import 'package:shipit_golden_app/features/programs/presentation/screens/program_details_screen.dart';
import 'package:shipit_ui/shipit_ui.dart';

class MockProgramsRepository extends Mock implements ProgramsRepository {}

Program _sampleProgram() {
  return Program(
    id: '1',
    name: 'Summer Camp',
    description: 'Annual summer camp',
    startDate: DateTime(2026, 6, 15),
    endDate: DateTime(2026, 8, 15),
    status: 'active',
  );
}

void main() {
  late MockProgramsRepository repository;

  setUp(() {
    repository = MockProgramsRepository();
  });

  Widget wrap(Widget child) {
    return MaterialApp(theme: shipitLightTheme(), home: child);
  }

  Widget screen({required String programId}) {
    return BlocProvider(
      create: (_) =>
          ProgramDetailsBloc(programId: programId, repository: repository)
            ..add(const ProgramDetailsStarted()),
      child: const ProgramDetailsView(),
    );
  }

  void stubLoad({required bool isJoined}) {
    when(
      () => repository.getProgramById('1'),
    ).thenAnswer((_) async => Result.success(_sampleProgram()));
    when(
      () => repository.isJoined('1'),
    ).thenAnswer((_) async => Result.success(isJoined));
  }

  testWidgets('renders program details with a join CTA', (tester) async {
    stubLoad(isJoined: false);

    await tester.pumpWidget(wrap(screen(programId: '1')));
    await tester.pumpAndSettle();

    expect(find.text('Summer Camp'), findsOneWidget);
    expect(find.text('Annual summer camp'), findsOneWidget);
    expect(find.text('15/6/2026 - 15/8/2026'), findsOneWidget);
    expect(find.text('ACTIVE'), findsOneWidget);
    expect(find.text('Join Program'), findsOneWidget);
    expect(find.text('Cancel Membership'), findsNothing);
  });

  testWidgets('renders cancel membership CTA when already joined', (
    tester,
  ) async {
    stubLoad(isJoined: true);

    await tester.pumpWidget(wrap(screen(programId: '1')));
    await tester.pumpAndSettle();

    expect(find.text('Join Program'), findsNothing);
    expect(find.text('Cancel Membership'), findsOneWidget);
  });

  testWidgets('joining flips the CTA to cancel membership', (tester) async {
    stubLoad(isJoined: false);
    when(
      () => repository.joinProgram('1'),
    ).thenAnswer((_) async => Result.success(true));

    await tester.pumpWidget(wrap(screen(programId: '1')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Join Program'));
    await tester.pumpAndSettle();

    expect(find.text('Join Program'), findsNothing);
    expect(find.text('Cancel Membership'), findsOneWidget);
  });

  testWidgets('cancelling confirms then flips back to the join CTA', (
    tester,
  ) async {
    stubLoad(isJoined: true);
    when(
      () => repository.cancelMembership('1'),
    ).thenAnswer((_) async => Result.success(false));

    await tester.pumpWidget(wrap(screen(programId: '1')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel Membership'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Are you sure'), findsOneWidget);

    await tester.tap(find.text('Cancel Membership').last);
    await tester.pumpAndSettle();

    expect(find.textContaining('Are you sure'), findsNothing);
    expect(find.text('Join Program'), findsOneWidget);
    expect(find.text('Cancel Membership'), findsNothing);
  });

  testWidgets('shows a retryable error when loading fails', (tester) async {
    when(() => repository.getProgramById('1')).thenAnswer(
      (_) async => Result.failure(const AppFailure.network(message: 'offline')),
    );

    await tester.pumpWidget(wrap(screen(programId: '1')));
    await tester.pumpAndSettle();

    expect(find.byType(AppInlineAlert), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets(
    'a failed join keeps the loaded content and shows an inline alert',
    (tester) async {
      stubLoad(isJoined: false);
      when(() => repository.joinProgram('1')).thenAnswer(
        (_) async =>
            Result.failure(const AppFailure.network(message: 'offline')),
      );

      await tester.pumpWidget(wrap(screen(programId: '1')));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Join Program'));
      await tester.pumpAndSettle();

      expect(find.text('Summer Camp'), findsOneWidget);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      expect(find.text('Join Program'), findsOneWidget);
    },
  );

  testWidgets('the inline mutation alert is dismissible', (tester) async {
    stubLoad(isJoined: false);
    when(() => repository.joinProgram('1')).thenAnswer(
      (_) async => Result.failure(const AppFailure.network(message: 'offline')),
    );

    await tester.pumpWidget(wrap(screen(programId: '1')));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Join Program'));
    await tester.pumpAndSettle();
    expect(find.byType(AppInlineAlert), findsOneWidget);

    await tester.tap(find.byKey(AppInlineAlert.dismissKey));
    await tester.pumpAndSettle();

    expect(find.byType(AppInlineAlert), findsNothing);
    expect(find.text('Summer Camp'), findsOneWidget);
  });

  testWidgets('renders loading skeletons before the details resolve', (
    tester,
  ) async {
    final programCompleter = Completer<Result<Program>>();
    when(
      () => repository.getProgramById('1'),
    ).thenAnswer((_) => programCompleter.future);
    when(
      () => repository.isJoined('1'),
    ).thenAnswer((_) async => Result.success(false));

    await tester.pumpWidget(wrap(screen(programId: '1')));
    await tester.pump();

    expect(find.byType(AppSkeleton), findsWidgets);
    expect(find.text('Summer Camp'), findsNothing);

    programCompleter.complete(Result.success(_sampleProgram()));
    await tester.pumpAndSettle();
    expect(find.byType(AppSkeleton), findsNothing);
    expect(find.text('Summer Camp'), findsOneWidget);
  });
}
