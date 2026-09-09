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

abstract class Household
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  Household._({
    this.id,
    required this.name,
    required this.ownerId,
    required this.createdAt,
  });

  factory Household({
    int? id,
    required String name,
    required String ownerId,
    required DateTime createdAt,
  }) = _HouseholdImpl;

  factory Household.fromJson(Map<String, dynamic> jsonSerialization) {
    return Household(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      ownerId: jsonSerialization['ownerId'] as String,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  static final t = HouseholdTable();

  static const db = HouseholdRepository._();

  @override
  int? id;

  String name;

  String ownerId;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [Household]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Household copyWith({
    int? id,
    String? name,
    String? ownerId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Household',
      if (id != null) 'id': id,
      'name': name,
      'ownerId': ownerId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Household',
      if (id != null) 'id': id,
      'name': name,
      'ownerId': ownerId,
      'createdAt': createdAt.toJson(),
    };
  }

  static HouseholdInclude include() {
    return HouseholdInclude._();
  }

  static HouseholdIncludeList includeList({
    _i1.WhereExpressionBuilder<HouseholdTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HouseholdTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HouseholdTable>? orderByList,
    HouseholdInclude? include,
  }) {
    return HouseholdIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Household.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Household.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _HouseholdImpl extends Household {
  _HouseholdImpl({
    int? id,
    required String name,
    required String ownerId,
    required DateTime createdAt,
  }) : super._(id: id, name: name, ownerId: ownerId, createdAt: createdAt);

  /// Returns a shallow copy of this [Household]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Household copyWith({
    Object? id = _Undefined,
    String? name,
    String? ownerId,
    DateTime? createdAt,
  }) {
    return Household(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class HouseholdUpdateTable extends _i1.UpdateTable<HouseholdTable> {
  HouseholdUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) =>
      _i1.ColumnValue(table.name, value);

  _i1.ColumnValue<String, String> ownerId(String value) =>
      _i1.ColumnValue(table.ownerId, value);

  _i1.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _i1.ColumnValue(table.createdAt, value);
}

class HouseholdTable extends _i1.Table<int?> {
  HouseholdTable({super.tableRelation}) : super(tableName: 'households') {
    updateTable = HouseholdUpdateTable(this);
    name = _i1.ColumnString('name', this);
    ownerId = _i1.ColumnString('ownerId', this);
    createdAt = _i1.ColumnDateTime('createdAt', this);
  }

  late final HouseholdUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString ownerId;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [id, name, ownerId, createdAt];
}

class HouseholdInclude extends _i1.IncludeObject {
  HouseholdInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => Household.t;
}

class HouseholdIncludeList extends _i1.IncludeList {
  HouseholdIncludeList._({
    _i1.WhereExpressionBuilder<HouseholdTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Household.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => Household.t;
}

class HouseholdRepository {
  const HouseholdRepository._();

  /// Returns a list of [Household]s matching the given query parameters.
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
  Future<List<Household>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HouseholdTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HouseholdTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HouseholdTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Household>(
      where: where?.call(Household.t),
      orderBy: orderBy?.call(Household.t),
      orderByList: orderByList?.call(Household.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Household] matching the given query parameters.
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
  Future<Household?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HouseholdTable>? where,
    int? offset,
    _i1.OrderByBuilder<HouseholdTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HouseholdTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Household>(
      where: where?.call(Household.t),
      orderBy: orderBy?.call(Household.t),
      orderByList: orderByList?.call(Household.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Household] by its [id] or null if no such row exists.
  Future<Household?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Household>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Household]s in the list and returns the inserted rows.
  ///
  /// The returned [Household]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Household>> insert(
    _i1.DatabaseSession session,
    List<Household> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Household>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Household] and returns the inserted row.
  ///
  /// The returned [Household] will have its `id` field set.
  Future<Household> insertRow(
    _i1.DatabaseSession session,
    Household row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Household>(row, transaction: transaction);
  }

  /// Updates all [Household]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Household>> update(
    _i1.DatabaseSession session,
    List<Household> rows, {
    _i1.ColumnSelections<HouseholdTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Household>(
      rows,
      columns: columns?.call(Household.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Household]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Household> updateRow(
    _i1.DatabaseSession session,
    Household row, {
    _i1.ColumnSelections<HouseholdTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Household>(
      row,
      columns: columns?.call(Household.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Household] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Household?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<HouseholdUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Household>(
      id,
      columnValues: columnValues(Household.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Household]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Household>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<HouseholdUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<HouseholdTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HouseholdTable>? orderBy,
    _i1.OrderByListBuilder<HouseholdTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Household>(
      columnValues: columnValues(Household.t.updateTable),
      where: where(Household.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Household.t),
      orderByList: orderByList?.call(Household.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Household]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Household>> delete(
    _i1.DatabaseSession session,
    List<Household> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Household>(rows, transaction: transaction);
  }

  /// Deletes a single [Household].
  Future<Household> deleteRow(
    _i1.DatabaseSession session,
    Household row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Household>(row, transaction: transaction);
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Household>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HouseholdTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Household>(
      where: where(Household.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HouseholdTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Household>(
      where: where?.call(Household.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Household] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HouseholdTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Household>(
      where: where(Household.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
