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

abstract class Program implements _i1.SerializableModel {
  Program._({
    this.id,
    required this.name,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory Program({
    int? id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) = _ProgramImpl;

  factory Program.fromJson(Map<String, dynamic> jsonSerialization) {
    return Program(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String,
      startDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      status: jsonSerialization['status'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String description;

  DateTime startDate;

  DateTime endDate;

  String status;

  /// Returns a shallow copy of this [Program]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Program copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Program',
      if (id != null) 'id': id,
      'name': name,
      'description': description,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'status': status,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProgramImpl extends Program {
  _ProgramImpl({
    int? id,
    required String name,
    required String description,
    required DateTime startDate,
    required DateTime endDate,
    required String status,
  }) : super._(
         id: id,
         name: name,
         description: description,
         startDate: startDate,
         endDate: endDate,
         status: status,
       );

  /// Returns a shallow copy of this [Program]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Program copyWith({
    Object? id = _Undefined,
    String? name,
    String? description,
    DateTime? startDate,
    DateTime? endDate,
    String? status,
  }) {
    return Program(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }
}
