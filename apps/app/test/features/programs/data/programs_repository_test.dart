import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/programs/data/programs_repository.dart';
import 'package:shipit_golden_app/features/programs/domain/program.dart';

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
  });
}
