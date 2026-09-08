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

abstract class HouseholdMember
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
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

  static final t = HouseholdMemberTable();

  static const db = HouseholdMemberRepository._();

  @override
  int? id;

  String householdId;

  String name;

  String email;

  String role;

  DateTime joinedAt;

  @override
  _i1.Table<int?> get table => t;

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
  Map<String, dynamic> toJsonForProtocol() {
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

  static HouseholdMemberInclude include() {
    return HouseholdMemberInclude._();
  }

  static HouseholdMemberIncludeList includeList({
    _i1.WhereExpressionBuilder<HouseholdMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HouseholdMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HouseholdMemberTable>? orderByList,
    HouseholdMemberInclude? include,
  }) {
    return HouseholdMemberIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HouseholdMember.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(HouseholdMember.t),
      include: include,
    );
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

class HouseholdMemberUpdateTable extends _i1.UpdateTable<HouseholdMemberTable> {
  HouseholdMemberUpdateTable(super.table);

  _i1.ColumnValue<String, String> householdId(String value) => _i1.ColumnValue(
    table.householdId,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> email(String value) => _i1.ColumnValue(
    table.email,
    value,
  );

  _i1.ColumnValue<String, String> role(String value) => _i1.ColumnValue(
    table.role,
    value,
  );

  _i1.ColumnValue<DateTime, DateTime> joinedAt(DateTime value) =>
      _i1.ColumnValue(
        table.joinedAt,
        value,
      );
}

class HouseholdMemberTable extends _i1.Table<int?> {
  HouseholdMemberTable({super.tableRelation})
    : super(tableName: 'household_members') {
    updateTable = HouseholdMemberUpdateTable(this);
    householdId = _i1.ColumnString(
      'householdId',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    email = _i1.ColumnString(
      'email',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
    );
    joinedAt = _i1.ColumnDateTime(
      'joinedAt',
      this,
    );
  }

  late final HouseholdMemberUpdateTable updateTable;

  late final _i1.ColumnString householdId;

  late final _i1.ColumnString name;

  late final _i1.ColumnString email;

  late final _i1.ColumnString role;

  late final _i1.ColumnDateTime joinedAt;

  @override
  List<_i1.Column> get columns => [
    id,
    householdId,
    name,
    email,
    role,
    joinedAt,
  ];
}

class HouseholdMemberInclude extends _i1.IncludeObject {
  HouseholdMemberInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => HouseholdMember.t;
}

class HouseholdMemberIncludeList extends _i1.IncludeList {
  HouseholdMemberIncludeList._({
    _i1.WhereExpressionBuilder<HouseholdMemberTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(HouseholdMember.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => HouseholdMember.t;
}

class HouseholdMemberRepository {
  const HouseholdMemberRepository._();

  /// Returns a list of [HouseholdMember]s matching the given query parameters.
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
  Future<List<HouseholdMember>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HouseholdMemberTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HouseholdMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HouseholdMemberTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<HouseholdMember>(
      where: where?.call(HouseholdMember.t),
      orderBy: orderBy?.call(HouseholdMember.t),
      orderByList: orderByList?.call(HouseholdMember.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [HouseholdMember] matching the given query parameters.
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
  Future<HouseholdMember?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HouseholdMemberTable>? where,
    int? offset,
    _i1.OrderByBuilder<HouseholdMemberTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<HouseholdMemberTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<HouseholdMember>(
      where: where?.call(HouseholdMember.t),
      orderBy: orderBy?.call(HouseholdMember.t),
      orderByList: orderByList?.call(HouseholdMember.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [HouseholdMember] by its [id] or null if no such row exists.
  Future<HouseholdMember?> findById(
    _i1.DatabaseSession session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<HouseholdMember>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [HouseholdMember]s in the list and returns the inserted rows.
  ///
  /// The returned [HouseholdMember]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<HouseholdMember>> insert(
    _i1.DatabaseSession session,
    List<HouseholdMember> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<HouseholdMember>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [HouseholdMember] and returns the inserted row.
  ///
  /// The returned [HouseholdMember] will have its `id` field set.
  Future<HouseholdMember> insertRow(
    _i1.DatabaseSession session,
    HouseholdMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<HouseholdMember>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [HouseholdMember]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<HouseholdMember>> update(
    _i1.DatabaseSession session,
    List<HouseholdMember> rows, {
    _i1.ColumnSelections<HouseholdMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<HouseholdMember>(
      rows,
      columns: columns?.call(HouseholdMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HouseholdMember]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<HouseholdMember> updateRow(
    _i1.DatabaseSession session,
    HouseholdMember row, {
    _i1.ColumnSelections<HouseholdMemberTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<HouseholdMember>(
      row,
      columns: columns?.call(HouseholdMember.t),
      transaction: transaction,
    );
  }

  /// Updates a single [HouseholdMember] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<HouseholdMember?> updateById(
    _i1.DatabaseSession session,
    int id, {
    required _i1.ColumnValueListBuilder<HouseholdMemberUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<HouseholdMember>(
      id,
      columnValues: columnValues(HouseholdMember.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [HouseholdMember]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<HouseholdMember>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<HouseholdMemberUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<HouseholdMemberTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<HouseholdMemberTable>? orderBy,
    _i1.OrderByListBuilder<HouseholdMemberTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<HouseholdMember>(
      columnValues: columnValues(HouseholdMember.t.updateTable),
      where: where(HouseholdMember.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(HouseholdMember.t),
      orderByList: orderByList?.call(HouseholdMember.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [HouseholdMember]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<HouseholdMember>> delete(
    _i1.DatabaseSession session,
    List<HouseholdMember> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<HouseholdMember>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [HouseholdMember].
  Future<HouseholdMember> deleteRow(
    _i1.DatabaseSession session,
    HouseholdMember row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<HouseholdMember>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<HouseholdMember>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HouseholdMemberTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<HouseholdMember>(
      where: where(HouseholdMember.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<HouseholdMemberTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<HouseholdMember>(
      where: where?.call(HouseholdMember.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [HouseholdMember] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<HouseholdMemberTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<HouseholdMember>(
      where: where(HouseholdMember.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
