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

abstract class Program
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = ProgramTable();

  static const db = ProgramRepository._();

  @override
  int? id;

  String name;

  String description;

  DateTime startDate;

  DateTime endDate;

  String status;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static ProgramInclude include() {
    return ProgramInclude._();
  }

  static ProgramIncludeList includeList({
    _i1.WhereExpressionBuilder<ProgramTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProgramTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProgramTable>? orderByList,
    ProgramInclude? include,
  }) {
    return ProgramIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Program.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Program.t),
      include: include,
    );
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

class ProgramUpdateTable extends _i1.UpdateTable<ProgramTable> {
  ProgramUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) =>
      _i1.ColumnValue(table.name, value);

  _i1.ColumnValue<String, String> description(String value) =>
      _i1.ColumnValue(table.description, value);

  _i1.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _i1.ColumnValue(table.startDate, value);

  _i1.ColumnValue<DateTime, DateTime> endDate(DateTime value) =>
      _i1.ColumnValue(table.endDate, value);

  _i1.ColumnValue<String, String> status(String value) =>
      _i1.ColumnValue(table.status, value);
}

class ProgramTable extends _i1.Table<int?> {
  ProgramTable({super.tableRelation}) : super(tableName: 'programs') {
    updateTable = ProgramUpdateTable(this);
    name = _i1.ColumnString('name', this);
    description = _i1.ColumnString('description', this);
    startDate = _i1.ColumnDateTime('startDate', this);
    endDate = _i1.ColumnDateTime('endDate', this);
    status = _i1.ColumnString('status', this);
  }

  late final ProgramUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString description;

  late final _i1.ColumnDateTime startDate;

  late final _i1.ColumnDateTime endDate;

  late final _i1.ColumnString status;

  @override
  List<_i1.Column> get columns => [
    id,
    name,
    description,
    startDate,
    endDate,
    status,
  ];
}

class ProgramInclude extends _i1.IncludeObject {
  ProgramInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Program.t;
}

class ProgramIncludeList extends _i1.IncludeList {
  ProgramIncludeList._({
    _i1.WhereExpressionBuilder<ProgramTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Program.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Program.t;
}

class ProgramRepository {
  const ProgramRepository._();

  /// Returns a list of [Program]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Program>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProgramTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProgramTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProgramTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Program>(
      where: where?.call(Program.t),
      orderBy: orderBy?.call(Program.t),
      orderByList: orderByList?.call(Program.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Program] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Program?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProgramTable>? where,
    int? offset,
    _i1.OrderByBuilder<ProgramTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<ProgramTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Program>(
      where: where?.call(Program.t),
      orderBy: orderBy?.call(Program.t),
      orderByList: orderByList?.call(Program.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Program] by its [id] or null if no such row exists.
  Future<Program?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Program>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Program]s in the list and returns the inserted rows.
  ///
  /// The returned [Program]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Program>> insert(
    _i1.DatabaseSession session,
    List<Program> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Program>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Program] and returns the inserted row.
  ///
  /// The returned [Program] will have its `id` field set.
  Future<Program> insertRow(
    _i1.DatabaseSession session,
    Program row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Program>(row, transaction: transaction);
  }

  /// Updates all [Program]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Program>> update(
    _i1.DatabaseSession session,
    List<Program> rows, {
    _i1.ColumnSelections<ProgramTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Program>(
      rows,
      columns: columns?.call(Program.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Program]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Program> updateRow(
    _i1.DatabaseSession session,
    Program row, {
    _i1.ColumnSelections<ProgramTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Program>(
      row,
      columns: columns?.call(Program.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Program] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Program?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<ProgramUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Program>(
      id,
      columnValues: columnValues(Program.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Program]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Program>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<ProgramUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<ProgramTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<ProgramTable>? orderBy,
    _i1.OrderByListBuilder<ProgramTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Program>(
      columnValues: columnValues(Program.t.updateTable),
      where: where(Program.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Program.t),
      orderByList: orderByList?.call(Program.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Program]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Program>> delete(
    _i1.DatabaseSession session,
    List<Program> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Program>(rows, transaction: transaction);
  }

  /// Deletes a single [Program].
  Future<Program> deleteRow(
    _i1.DatabaseSession session,
    Program row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Program>(row, transaction: transaction);
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Program>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProgramTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Program>(
      where: where(Program.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<ProgramTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Program>(
      where: where?.call(Program.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Program] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<ProgramTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Program>(
      where: where(Program.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
