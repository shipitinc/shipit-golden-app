import 'package:flutter_test/flutter_test.dart';
import 'package:shipit_golden_app/core/core.dart';

void main() {
  group('Result', () {
    test('success exposes the value', () {
      final result = Result<int>.success(42);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.getOrThrow(), 42);
    });

    test('failure exposes the failure and throws on getOrThrow', () {
      final failure = AppFailure.network(message: 'offline');
      final result = Result<int>.failure(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(() => result.getOrThrow(), throwsA(isA<NetworkFailure>()));
    });

    test('when dispatches to the success or failure path', () {
      final success = Result<String>.success('ok');
      final failure = Result<String>.failure(AppFailure.server(message: '500'));

      String? successSeen;
      String? failureSeen;
      success.when(
        success: (value) => successSeen = value,
        failure: (f) => failureSeen = f.userMessage,
      );
      expect(successSeen, 'ok');
      expect(failureSeen, isNull);

      success.when(
        success: (value) => successSeen = value,
        failure: (f) => failureSeen = f.userMessage,
      );
      expect(successSeen, 'ok');

      failure.when(
        success: (value) => successSeen = value,
        failure: (f) => failureSeen = f.userMessage,
      );
      expect(failureSeen, 'Server error: 500');
    });
  });

  group('AppFailure userMessage', () {
    test('maps each failure type to a human readable message', () {
      expect(AppFailure.network(message: 'x').userMessage, 'Network error: x');
      expect(AppFailure.auth(message: 'x').userMessage, 'x');
      expect(
        AppFailure.authorization(message: 'x').userMessage,
        'Access denied: x',
      );
      expect(
        AppFailure.validation(message: 'x').userMessage,
        'Validation error: x',
      );
      expect(
        AppFailure.server(message: 'x', statusCode: 500).userMessage,
        'Server error: x',
      );
      expect(
        AppFailure.unknown(message: 'x').userMessage,
        'An unexpected error occurred: x',
      );
    });
  });
}
