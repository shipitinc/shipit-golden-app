/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;

/// Serialized to the app client so the registration form can tell the user
/// that an account already exists for the email they entered.
///
/// Serverpod's built-in email IDP deliberately swallows this case (anti
/// account-enumeration) and returns a fake registration request id. The golden
/// app overrides AuthEndpoint.startRegistration to surface it as first-class
/// product behaviour, at the cost of leaking whether an email is registered.
abstract class EmailAlreadyRegisteredException
    implements
        _i1.SerializableException,
        _i1.SerializableModel,
        _i1.ProtocolSerialization {
  EmailAlreadyRegisteredException._();

  factory EmailAlreadyRegisteredException() =
      _EmailAlreadyRegisteredExceptionImpl;

  factory EmailAlreadyRegisteredException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return EmailAlreadyRegisteredException();
  }

  /// Returns a shallow copy of this [EmailAlreadyRegisteredException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EmailAlreadyRegisteredException copyWith();
  @override
  Map<String, dynamic> toJson() {
    return {'__className__': 'EmailAlreadyRegisteredException'};
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {'__className__': 'EmailAlreadyRegisteredException'};
  }

  @override
  String toString() {
    return 'EmailAlreadyRegisteredException';
  }
}

class _EmailAlreadyRegisteredExceptionImpl
    extends EmailAlreadyRegisteredException {
  _EmailAlreadyRegisteredExceptionImpl() : super._();

  /// Returns a shallow copy of this [EmailAlreadyRegisteredException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EmailAlreadyRegisteredException copyWith() {
    return EmailAlreadyRegisteredException();
  }
}
