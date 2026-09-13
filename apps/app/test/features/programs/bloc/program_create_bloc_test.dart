import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_create_state.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

class MockProgramsRepository extends Mock implements ProgramsRepository {}

void main() {
  late MockProgramsRepository repository;
  late ProgramCreateBloc bloc;

  final created = Program(
    id: '42',
    name: 'Summer Camp',
    description: 'Annual summer camp',
    startDate: DateTime(2026, 6, 15),
    endDate: DateTime(2026, 8, 15),
    status: 'active',
  );

  final startDate = DateTime(2026, 6, 15);
  final endDate = DateTime(2026, 8, 15);

  setUp(() {
    repository = MockProgramsRepository();
    bloc = ProgramCreateBloc(repository: repository);
  });

  tearDown(() => bloc.close());

  group('ProgramCreateBloc', () {
    test('initial state is initial', () {
      expect(bloc.state, const ProgramCreateState.initial());
    });

    blocTest<ProgramCreateBloc, ProgramCreateState>(
      'submitting a valid form forwards arguments and emits completed',
      build: () {
        when(
          () => repository.createProgram(
            name: 'Summer Camp',
            description: 'Annual summer camp',
            startDate: startDate,
            endDate: endDate,
          ),
        ).thenAnswer((_) async => Result.success(created));
        return bloc;
      },
      act: (bloc) => bloc.add(
        ProgramCreateSubmitted(
          name: 'Summer Camp',
          description: 'Annual summer camp',
          startDate: startDate,
          endDate: endDate,
        ),
      ),
      expect: () => const [
        ProgramCreateState.submitting(),
        ProgramCreateState.completed(),
      ],
    );

    blocTest<ProgramCreateBloc, ProgramCreateState>(
      'emits failure when the create fails and settles on the form',
      build: () {
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
        return bloc;
      },
      act: (bloc) => bloc.add(
        ProgramCreateSubmitted(
          name: 'Summer Camp',
          description: '',
          startDate: startDate,
          endDate: endDate,
        ),
      ),
      expect: () => [
        const ProgramCreateState.submitting(),
        ProgramCreateState.failure(
          submitError: AppFailure.network(message: 'offline'),
        ),
      ],
    );

    blocTest<ProgramCreateBloc, ProgramCreateState>(
      'dismissing the error returns to the idle form',
      build: () {
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
        return bloc;
      },
      act: (bloc) async {
        bloc.add(
          ProgramCreateSubmitted(
            name: 'Summer Camp',
            description: '',
            startDate: startDate,
            endDate: endDate,
          ),
        );
        await Future<void>.delayed(Duration.zero); // let the failure settle
        bloc.add(const ProgramCreateErrorDismissed());
      },
      expect: () => [
        const ProgramCreateState.submitting(),
        ProgramCreateState.failure(
          submitError: AppFailure.network(message: 'offline'),
        ),
        const ProgramCreateState.initial(),
      ],
    );

    test('a submission while one is in flight is ignored', () async {
      final completer = Completer<Result<Program>>();
      when(
        () => repository.createProgram(
          name: any(named: 'name'),
          description: any(named: 'description'),
          startDate: any(named: 'startDate'),
          endDate: any(named: 'endDate'),
        ),
      ).thenAnswer((_) => completer.future);

      final bloc = ProgramCreateBloc(repository: repository);
      addTearDown(bloc.close);

      bloc.add(
        ProgramCreateSubmitted(
          name: 'One',
          description: '',
          startDate: startDate,
          endDate: endDate,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, const ProgramCreateState.submitting());

      bloc.add(
        ProgramCreateSubmitted(
          name: 'Two',
          description: '',
          startDate: startDate,
          endDate: endDate,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, const ProgramCreateState.submitting());

      // Unblock the in-flight submission so the bloc closes cleanly.
      completer.complete(Result.success(created));
      await Future<void>.delayed(Duration.zero);
      expect(bloc.state, const ProgramCreateState.completed());
    });

    blocTest<ProgramCreateBloc, ProgramCreateState>(
      'ignores submissions after completing',
      build: () {
        when(
          () => repository.createProgram(
            name: any(named: 'name'),
            description: any(named: 'description'),
            startDate: any(named: 'startDate'),
            endDate: any(named: 'endDate'),
          ),
        ).thenAnswer((_) async => Result.success(created));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(
          ProgramCreateSubmitted(
            name: 'One',
            description: '',
            startDate: startDate,
            endDate: endDate,
          ),
        );
        await Future<void>.delayed(Duration.zero);
        bloc.add(
          ProgramCreateSubmitted(
            name: 'Two',
            description: '',
            startDate: startDate,
            endDate: endDate,
          ),
        );
      },
      expect: () => const [
        ProgramCreateState.submitting(),
        ProgramCreateState.completed(),
      ],
    );
  });
}
