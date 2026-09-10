import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shipit_golden_app/core/core.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_event.dart';
import 'package:shipit_golden_app/features/authentication/bloc/authentication_state.dart';
import 'package:shipit_golden_app/features/authentication/data/auth_repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthRepository _authRepository;

  AuthenticationBloc({AuthRepository? authRepository})
    : _authRepository = authRepository ?? AuthRepository(),
      super(const AuthenticationState.initial()) {
    on<AuthenticationStarted>(_onStarted);
    on<AuthenticationLoginRequested>(_onLoginRequested);
    on<AuthenticationRegisterRequested>(_onRegisterRequested);
    on<AuthenticationVerifyRegistrationCode>(_onVerifyRegistrationCode);
    on<AuthenticationLogoutRequested>(_onLogoutRequested);
    on<AuthenticationSessionExpired>(_onSessionExpired);
  }

  Future<void> _onStarted(
    AuthenticationStarted event,
    Emitter<AuthenticationState> emit,
  ) async {
    try {
      await _authRepository.restoreSession();
      if (_authRepository.isAuthenticated) {
        final info = _authRepository.authInfo!;
        emit(AuthenticationState.authenticated(token: info.token, email: ''));
        return;
      }
    } catch (e) {
      // Secure-storage/keychain failures must not crash startup; fall through
      // to the unauthenticated state. Log so the failure is not invisible.
      debugPrint('[authentication] session restore failed: $e');
    }
    emit(const AuthenticationState.unauthenticated());
  }

  Future<void> _onLoginRequested(
    AuthenticationLoginRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.loading());
    final result = await _authRepository.login(event.email, event.password);
    result.when(
      success: (auth) => emit(
        AuthenticationState.authenticated(
          token: auth.token,
          email: event.email,
        ),
      ),
      failure: (failure) => emit(AuthenticationState.failure(failure: failure)),
    );
  }

  Future<void> _onRegisterRequested(
    AuthenticationRegisterRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.loading());
    final result = await _authRepository.startRegistration(event.email);
    result.when(
      success: (requestId) => emit(
        AuthenticationState.registrationCodeSent(
          email: event.email,
          accountRequestId: requestId.toString(),
        ),
      ),
      failure: (failure) => emit(AuthenticationState.failure(failure: failure)),
    );
  }

  Future<void> _onVerifyRegistrationCode(
    AuthenticationVerifyRegistrationCode event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(const AuthenticationState.registrationSubmitting());
    final result = await _authRepository.completeRegistration(
      accountRequestId: event.accountRequestId,
      verificationCode: event.verificationCode,
      password: event.password,
    );
    result.when(
      success: (auth) => emit(
        AuthenticationState.authenticated(
          token: auth.token,
          email: event.email,
        ),
      ),
      failure: (failure) => emit(AuthenticationState.failure(failure: failure)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthenticationLogoutRequested event,
    Emitter<AuthenticationState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthenticationState.unauthenticated());
  }

  Future<void> _onSessionExpired(
    AuthenticationSessionExpired event,
    Emitter<AuthenticationState> emit,
  ) async {
    debugPrint('[authentication] session expired; ending local session');
    try {
      await _authRepository.logout();
    } catch (e) {
      // Clearing the local session must not throw the app into an error
      // screen; the unauthenticated state below is authoritative regardless.
      debugPrint('[authentication] failed to clear session on expiry: $e');
    }
    emit(const AuthenticationState.unauthenticated());
  }
}
