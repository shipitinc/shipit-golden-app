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

import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class HouseholdMember implements _i1.SerializableModel {
  HouseholdMember._({
    this.id,
    required this.householdId,
    required this.name,
    required this.email,
    required this.role,
    required this.joinedAt,
  });

  factory HouseholdMember({
    int? id,
    required String householdId,
    required String name,
    required String email,
    required String role,
    required DateTime joinedAt,
  }) = _HouseholdMemberImpl;

  factory HouseholdMember.fromJson(Map<String, dynamic> jsonSerialization) {
    return HouseholdMember(
      id: jsonSerialization['id'] as int?,
      householdId: jsonSerialization['householdId'] as String,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      role: jsonSerialization['role'] as String,
      joinedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String householdId;

  String name;

  String email;

  String role;

  DateTime joinedAt;

  /// Returns a shallow copy of this [HouseholdMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HouseholdMember copyWith({
    int? id,
    String? householdId,
    String? name,
    String? email,
    String? role,
    DateTime? joinedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HouseholdMember',
      if (id != null) 'id': id,
      'householdId': householdId,
      'name': name,
      'email': email,
      'role': role,
      'joinedAt': joinedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HouseholdMemberImpl extends HouseholdMember {
  _HouseholdMemberImpl({
    int? id,
    required String householdId,
    required String name,
    required String email,
    required String role,
    required DateTime joinedAt,
  }) : super._(
         id: id,
         householdId: householdId,
         name: name,
         email: email,
         role: role,
         joinedAt: joinedAt,
       );

  /// Returns a shallow copy of this [HouseholdMember]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HouseholdMember copyWith({
    Object? id = _Undefined,
    String? householdId,
    String? name,
    String? email,
    String? role,
    DateTime? joinedAt,
  }) {
    return HouseholdMember(
      id: id is int? ? id : this.id,
      householdId: householdId ?? this.householdId,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
