import 'package:app_client/app_client.dart' as api;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

class MockServerpodClientProvider extends Mock
    implements ServerpodClientProvider {}

class MockClient extends Mock implements api.Client {}

class MockProgramsEndpoint extends Mock implements api.EndpointPrograms {}

void main() {
  group('ProgramsRepository', () {
    late ProgramsRepository repository;

    setUp(() {
      repository = ProgramsRepository();
    });

    test(
      'getProgramById rejects a non-numeric id without a network call',
      () async {
        final result = await repository.getProgramById('not-a-number');

        expect(result, isA<Failure<Program>>());
        expect((result as Failure<Program>).failure, isA<ValidationFailure>());
      },
    );

    test('isJoined rejects a non-numeric id without a network call', () async {
      final result = await repository.isJoined('not-a-number');

      expect(result, isA<Failure<bool>>());
      expect((result as Failure<bool>).failure, isA<ValidationFailure>());
    });

    test(
      'joinProgram rejects a non-numeric id without a network call',
      () async {
        final result = await repository.joinProgram('not-a-number');

        expect(result, isA<Failure<bool>>());
        expect((result as Failure<bool>).failure, isA<ValidationFailure>());
      },
    );

    test(
      'cancelMembership rejects a non-numeric id without a network call',
      () async {
        final result = await repository.cancelMembership('not-a-number');

        expect(result, isA<Failure<bool>>());
        expect((result as Failure<bool>).failure, isA<ValidationFailure>());
      },
    );

    group('createProgram', () {
      late MockServerpodClientProvider provider;
      late MockClient client;
      late MockProgramsEndpoint endpoint;

      setUp(() {
        provider = MockServerpodClientProvider();
        client = MockClient();
        endpoint = MockProgramsEndpoint();
        when(() => provider.client).thenReturn(client);
        when(() => client.programs).thenReturn(endpoint);
        repository = ProgramsRepository(clientProvider: provider);
      });

      test('returns the created program converted to the domain', () async {
        final startDate = DateTime(2026, 6, 15);
        final endDate = DateTime(2026, 8, 15);
        when(
          () => endpoint.createProgram(
            'Summer Camp',
            'Annual summer camp',
            startDate,
            endDate,
          ),
        ).thenAnswer(
          (_) async => api.Program(
            id: 42,
            name: 'Summer Camp',
            description: 'Annual summer camp',
            createdBy: 'household-1',
            startDate: startDate,
            endDate: endDate,
            status: api.ProgramStatus.active,
          ),
        );

        final result = await repository.createProgram(
          name: 'Summer Camp',
          description: 'Annual summer camp',
          startDate: startDate,
          endDate: endDate,
        );

        expect(result, isA<Success<Program>>());
        final program = (result as Success<Program>).value;
        expect(program.id, '42');
        expect(program.name, 'Summer Camp');
        expect(program.description, 'Annual summer camp');
        expect(program.startDate, startDate);
        expect(program.endDate, endDate);
        expect(program.status, 'active');
      });

      test(
        'returns a validation failure when the server rejects the payload',
        () async {
          when(
            () => endpoint.createProgram(any(), any(), any(), any()),
          ).thenThrow(ServerpodClientBadRequest());

          final result = await repository.createProgram(
            name: 'X',
            description: '',
            startDate: DateTime(2026, 6, 15),
            endDate: DateTime(2026, 8, 15),
          );

          expect(result, isA<Failure<Program>>());
          expect(
            (result as Failure<Program>).failure,
            isA<ValidationFailure>(),
          );
        },
      );

      test(
        'returns a network failure when the client cannot reach the server',
        () async {
          when(
            () => endpoint.createProgram(any(), any(), any(), any()),
          ).thenThrow(const ServerpodClientException('', 0));

          final result = await repository.createProgram(
            name: 'X',
            description: '',
            startDate: DateTime(2026, 6, 15),
            endDate: DateTime(2026, 8, 15),
          );

          expect(result, isA<Failure<Program>>());
          expect((result as Failure<Program>).failure, isA<NetworkFailure>());
        },
      );
    });
  });
}
