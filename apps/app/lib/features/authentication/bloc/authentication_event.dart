import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_event.freezed.dart';

@freezed
sealed class AuthenticationEvent with _$AuthenticationEvent {
  const factory AuthenticationEvent.started() = AuthenticationStarted;

  const factory AuthenticationEvent.loginRequested({
    required String email,
    required String password,
  }) = AuthenticationLoginRequested;

  /// Requests a registration verification code be sent to [email].
  const factory AuthenticationEvent.registerRequested({required String email}) =
      AuthenticationRegisterRequested;

  /// Submits the registration verification code and password to create an
  /// account and sign the user in.
  const factory AuthenticationEvent.verifyRegistrationCode({
    required String accountRequestId,
    required String verificationCode,
    required String password,
    required String email,
  }) = AuthenticationVerifyRegistrationCode;

  const factory AuthenticationEvent.logoutRequested() =
      AuthenticationLogoutRequested;

  /// A mid-session request was rejected because the JWT expired or was
  /// invalidated server-side. Ends the local session so the router redirect
  /// returns the user to the login screen.
  const factory AuthenticationEvent.sessionExpired() =
      AuthenticationSessionExpired;
}
