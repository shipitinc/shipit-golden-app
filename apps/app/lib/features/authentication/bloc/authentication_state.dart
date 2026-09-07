import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shipit_golden_app/core/errors/app_failure.dart';

part 'authentication_state.freezed.dart';

@freezed
sealed class AuthenticationState with _$AuthenticationState {
  const factory AuthenticationState.initial() = AuthenticationInitial;
  const factory AuthenticationState.loading() = AuthenticationLoading;
  const factory AuthenticationState.authenticated({
    required String token,
    required String email,
  }) = AuthenticationAuthenticated;
  const factory AuthenticationState.unauthenticated() =
      AuthenticationUnauthenticated;
  const factory AuthenticationState.failure({required AppFailure failure}) =
      AuthenticationFailure;

  /// A registration verification code has been requested and sent to the
  /// server console (development-only email delivery).
  const factory AuthenticationState.registrationCodeSent({
    required String email,
    required String accountRequestId,
  }) = AuthenticationRegistrationCodeSent;

  /// A registration verification code and password have been submitted but
  /// the account has not yet been created.
  const factory AuthenticationState.registrationSubmitting() =
      AuthenticationRegistrationSubmitting;
}
