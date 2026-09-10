import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_bloc.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_state.dart';
import 'package:shipit_golden_app/features/authentication/data/auth_repository.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

final _fakeAuth = AuthSuccess(
  token: 'new-token',
  authStrategy: 'jwt',
  authUserId: UuidValue.fromString('00000000-0000-0000-0000-000000000001'),
  scopeNames: const {},
);

void main() {
  late MockAuthRepository repository;
  late AuthenticationBloc bloc;

  setUp(() {
    repository = MockAuthRepository();
    bloc = AuthenticationBloc(authRepository: repository);
  });

  tearDown(() => bloc.close());

  group('AuthenticationBloc', () {
    test('initial state is initial', () {
      expect(bloc.state, const AuthenticationState.initial());
    });

    blocTest<AuthenticationBloc, AuthenticationState>(
      'starts unauthenticated when no session is restored',
      build: () {
        when(() => repository.restoreSession()).thenAnswer((_) async {});
        when(() => repository.isAuthenticated).thenReturn(false);
        return bloc;
      },
      act: (bloc) => bloc.add(const AuthenticationEvent.started()),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'restores the session when authenticated',
      build: () {
        when(() => repository.restoreSession()).thenAnswer((_) async {});
        when(() => repository.isAuthenticated).thenReturn(true);
        when(() => repository.authInfo).thenReturn(_fakeAuth);
        return bloc;
      },
      act: (bloc) => bloc.add(const AuthenticationEvent.started()),
      expect: () => [
        const AuthenticationState.authenticated(token: 'new-token', email: ''),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'falls through to unauthenticated when session restore throws',
      build: () {
        when(
          () => repository.restoreSession(),
        ).thenAnswer((_) async => throw Exception('keychain-unavailable'));
        return bloc;
      },
      act: (bloc) => bloc.add(const AuthenticationEvent.started()),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits authenticated when login succeeds',
      build: () {
        when(
          () => repository.login('user@example.com', 'pw'),
        ).thenAnswer((_) async => Result.success(_fakeAuth));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthenticationEvent.loginRequested(
          email: 'user@example.com',
          password: 'pw',
        ),
      ),
      expect: () => [
        const AuthenticationState.loading(),
        const AuthenticationState.authenticated(
          token: 'new-token',
          email: 'user@example.com',
        ),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits failure when login fails',
      build: () {
        when(() => repository.login('user@example.com', 'bad')).thenAnswer(
          (_) async =>
              Result.failure(AppFailure.auth(message: 'Invalid credentials')),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthenticationEvent.loginRequested(
          email: 'user@example.com',
          password: 'bad',
        ),
      ),
      expect: () => [
        const AuthenticationState.loading(),
        AuthenticationState.failure(
          failure: AppFailure.auth(message: 'Invalid credentials'),
        ),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits codeSent when registration request succeeds',
      build: () {
        when(() => repository.startRegistration('user@example.com')).thenAnswer(
          (_) async => Result.success(
            UuidValue.fromString('00000000-0000-0000-0000-000000000002'),
          ),
        );
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthenticationEvent.registerRequested(email: 'user@example.com'),
      ),
      expect: () => [
        const AuthenticationState.loading(),
        const AuthenticationState.registrationCodeSent(
          email: 'user@example.com',
          accountRequestId: '00000000-0000-0000-0000-000000000002',
        ),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits authenticated when registration completes',
      build: () {
        when(
          () => repository.completeRegistration(
            accountRequestId: '00000000-0000-0000-0000-000000000002',
            verificationCode: '123456',
            password: 'password',
          ),
        ).thenAnswer((_) async => Result.success(_fakeAuth));
        return bloc;
      },
      act: (bloc) => bloc.add(
        const AuthenticationEvent.verifyRegistrationCode(
          accountRequestId: '00000000-0000-0000-0000-000000000002',
          verificationCode: '123456',
          password: 'password',
          email: 'user@example.com',
        ),
      ),
      expect: () => [
        const AuthenticationState.registrationSubmitting(),
        const AuthenticationState.authenticated(
          token: 'new-token',
          email: 'user@example.com',
        ),
      ],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'emits unauthenticated after logout',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => const AuthenticationState.authenticated(
        token: 't',
        email: 'user@example.com',
      ),
      act: (bloc) => bloc.add(const AuthenticationEvent.logoutRequested()),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'ends the session when a mid-session JWT expires',
      build: () {
        when(() => repository.logout()).thenAnswer((_) async {});
        return bloc;
      },
      seed: () => const AuthenticationState.authenticated(
        token: 'expired-token',
        email: 'user@example.com',
      ),
      act: (bloc) => bloc.add(const AuthenticationEvent.sessionExpired()),
      expect: () => [const AuthenticationState.unauthenticated()],
    );

    blocTest<AuthenticationBloc, AuthenticationState>(
      'still ends the session when clearing storage fails on expiry',
      build: () {
        when(
          () => repository.logout(),
        ).thenAnswer((_) async => throw Exception('keychain-unavailable'));
        return bloc;
      },
      seed: () => const AuthenticationState.authenticated(
        token: 'expired-token',
        email: 'user@example.com',
      ),
      act: (bloc) => bloc.add(const AuthenticationEvent.sessionExpired()),
      expect: () => [const AuthenticationState.unauthenticated()],
    );
  });
}
