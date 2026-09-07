import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_bloc.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_event.dart';
import 'package:shipit_golden_app/features/programs/bloc/programs_state.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

class MockProgramsRepository extends Mock implements ProgramsRepository {}

void main() {
  late MockProgramsRepository repository;
  late ProgramsBloc bloc;

  setUp(() {
    repository = MockProgramsRepository();
    bloc = ProgramsBloc(repository: repository);
  });

  tearDown(() => bloc.close());

  group('ProgramsBloc', () {
    test('initial state is initial', () {
      expect(bloc.state, const ProgramsState.initial());
    });

    blocTest<ProgramsBloc, ProgramsState>(
      'emits loading then loaded with programs',
      build: () {
        when(() => repository.getPrograms()).thenAnswer(
          (_) async => Result.success([
            Program(
              id: '1',
              name: 'Summer Camp',
              description: 'Annual summer camp',
              startDate: DateTime(2026, 6, 15),
              endDate: DateTime(2026, 8, 15),
              status: 'active',
            ),
          ]),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const ProgramsEvent.started()),
      expect: () => [
        const ProgramsState.loading(),
        ProgramsState.loaded(
          programs: [
            Program(
              id: '1',
              name: 'Summer Camp',
              description: 'Annual summer camp',
              startDate: DateTime(2026, 6, 15),
              endDate: DateTime(2026, 8, 15),
              status: 'active',
            ),
          ],
        ),
      ],
    );

    blocTest<ProgramsBloc, ProgramsState>(
      'emits failure when the fetch fails',
      build: () {
        when(() => repository.getPrograms()).thenAnswer(
          (_) async => Result.failure(AppFailure.network(message: 'offline')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(const ProgramsEvent.started()),
      expect: () => [
        const ProgramsState.loading(),
        ProgramsState.failure(failure: AppFailure.network(message: 'offline')),
      ],
    );
  });
}
