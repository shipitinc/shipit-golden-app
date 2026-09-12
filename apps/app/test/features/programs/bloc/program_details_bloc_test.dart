import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/program_details_state.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

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
  late ProgramDetailsBloc bloc;

  setUp(() {
    repository = MockProgramsRepository();
    bloc = ProgramDetailsBloc(programId: '1', repository: repository);
  });

  tearDown(() => bloc.close());

  ProgramDetailsState loaded({bool isJoined = false, bool isMutating = false}) {
    return ProgramDetailsState.loaded(
      program: _sampleProgram(),
      isJoined: isJoined,
      isMutating: isMutating,
    );
  }

  group('ProgramDetailsBloc', () {
    test('initial state is initial', () {
      expect(bloc.state, const ProgramDetailsState.initial());
    });

    blocTest<ProgramDetailsBloc, ProgramDetailsState>(
      'emits loading then loaded with program and membership status',
      build: () {
        when(
          () => repository.getProgramById('1'),
        ).thenAnswer((_) async => Result.success(_sampleProgram()));
        when(
          () => repository.isJoined('1'),
        ).thenAnswer((_) async => Result.success(true));
        return bloc;
      },
      act: (bloc) => bloc.add(const ProgramDetailsStarted()),
      expect: () => [
        const ProgramDetailsState.loading(),
        loaded(isJoined: true),
      ],
    );

    blocTest<ProgramDetailsBloc, ProgramDetailsState>(
      'emits failure when the program no longer exists',
      build: () {
        when(() => repository.getProgramById('1')).thenAnswer(
          (_) async => Result.failure(
            const AppFailure.validation(message: 'Program not found.'),
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const ProgramDetailsStarted()),
      expect: () => [
        const ProgramDetailsState.loading(),
        ProgramDetailsState.failure(
          failure: const AppFailure.validation(message: 'Program not found.'),
        ),
      ],
    );

    blocTest<ProgramDetailsBloc, ProgramDetailsState>(
      'join flips isJoined to true through a mutating state',
      build: () {
        when(
          () => repository.getProgramById('1'),
        ).thenAnswer((_) async => Result.success(_sampleProgram()));
        when(
          () => repository.isJoined('1'),
        ).thenAnswer((_) async => Result.success(false));
        when(
          () => repository.joinProgram('1'),
        ).thenAnswer((_) async => Result.success(true));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const ProgramDetailsStarted());
        await bloc.stream.firstWhere((s) => s is ProgramDetailsLoaded);
        bloc.add(const ProgramDetailsJoinRequested());
      },
      expect: () => [
        const ProgramDetailsState.loading(),
        loaded(),
        loaded(isMutating: true),
        loaded(isJoined: true),
      ],
    );

    blocTest<ProgramDetailsBloc, ProgramDetailsState>(
      'cancel flips isJoined to false through a mutating state',
      build: () {
        when(
          () => repository.getProgramById('1'),
        ).thenAnswer((_) async => Result.success(_sampleProgram()));
        when(
          () => repository.isJoined('1'),
        ).thenAnswer((_) async => Result.success(true));
        when(
          () => repository.cancelMembership('1'),
        ).thenAnswer((_) async => Result.success(false));
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const ProgramDetailsStarted());
        await bloc.stream.firstWhere((s) => s is ProgramDetailsLoaded);
        bloc.add(const ProgramDetailsCancelRequested());
      },
      expect: () => [
        const ProgramDetailsState.loading(),
        loaded(isJoined: true),
        loaded(isJoined: true, isMutating: true),
        loaded(isJoined: false),
      ],
    );

    blocTest<ProgramDetailsBloc, ProgramDetailsState>(
      'join failure stays loaded and surfaces an inline mutation error',
      build: () {
        when(
          () => repository.getProgramById('1'),
        ).thenAnswer((_) async => Result.success(_sampleProgram()));
        when(
          () => repository.isJoined('1'),
        ).thenAnswer((_) async => Result.success(false));
        when(() => repository.joinProgram('1')).thenAnswer(
          (_) async =>
              Result.failure(const AppFailure.network(message: 'offline')),
        );
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const ProgramDetailsStarted());
        await bloc.stream.firstWhere((s) => s is ProgramDetailsLoaded);
        bloc.add(const ProgramDetailsJoinRequested());
      },
      expect: () => [
        const ProgramDetailsState.loading(),
        loaded(),
        loaded(isMutating: true),
        ProgramDetailsState.loaded(
          program: _sampleProgram(),
          isJoined: false,
          mutationError: const AppFailure.network(message: 'offline'),
        ),
      ],
    );

    blocTest<ProgramDetailsBloc, ProgramDetailsState>(
      'cancel failure stays loaded and surfaces an inline mutation error',
      build: () {
        when(
          () => repository.getProgramById('1'),
        ).thenAnswer((_) async => Result.success(_sampleProgram()));
        when(
          () => repository.isJoined('1'),
        ).thenAnswer((_) async => Result.success(true));
        when(() => repository.cancelMembership('1')).thenAnswer(
          (_) async =>
              Result.failure(const AppFailure.network(message: 'offline')),
        );
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const ProgramDetailsStarted());
        await bloc.stream.firstWhere((s) => s is ProgramDetailsLoaded);
        bloc.add(const ProgramDetailsCancelRequested());
      },
      expect: () => [
        const ProgramDetailsState.loading(),
        loaded(isJoined: true),
        loaded(isJoined: true, isMutating: true),
        ProgramDetailsState.loaded(
          program: _sampleProgram(),
          isJoined: true,
          mutationError: const AppFailure.network(message: 'offline'),
        ),
      ],
    );

    blocTest<ProgramDetailsBloc, ProgramDetailsState>(
      'dismissing the mutation error clears it and keeps the loaded state',
      build: () {
        when(
          () => repository.getProgramById('1'),
        ).thenAnswer((_) async => Result.success(_sampleProgram()));
        when(
          () => repository.isJoined('1'),
        ).thenAnswer((_) async => Result.success(false));
        when(() => repository.joinProgram('1')).thenAnswer(
          (_) async =>
              Result.failure(const AppFailure.network(message: 'offline')),
        );
        return bloc;
      },
      act: (bloc) async {
        bloc.add(const ProgramDetailsStarted());
        await bloc.stream.firstWhere((s) => s is ProgramDetailsLoaded);
        bloc.add(const ProgramDetailsJoinRequested());
        await bloc.stream.firstWhere(
          (s) => s is ProgramDetailsLoaded && (s).mutationError != null,
        );
        bloc.add(const ProgramDetailsMutationErrorDismissed());
      },
      expect: () => [
        const ProgramDetailsState.loading(),
        loaded(),
        loaded(isMutating: true),
        ProgramDetailsState.loaded(
          program: _sampleProgram(),
          isJoined: false,
          mutationError: const AppFailure.network(message: 'offline'),
        ),
        loaded(isJoined: false),
      ],
    );
  });
}
