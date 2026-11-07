/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;

abstract class WhatsappContact
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  WhatsappContact._({
    this.id,
    required this.jid,
    this.name,
    this.phone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WhatsappContact({
    int? id,
    required String jid,
    String? name,
    String? phone,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WhatsappContactImpl;

  factory WhatsappContact.fromJson(Map<String, dynamic> jsonSerialization) {
    return WhatsappContact(
      id: jsonSerialization['id'] as int?,
      jid: jsonSerialization['jid'] as String,
      name: jsonSerialization['name'] as String?,
      phone: jsonSerialization['phone'] as String?,
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = WhatsappContactTable();

  static const db = WhatsappContactRepository._();

  @override
  int? id;

  String jid;

  String? name;

  String? phone;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [WhatsappContact]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WhatsappContact copyWith({
    int? id,
    String? jid,
    String? name,
    String? phone,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'jid': jid,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'jid': jid,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static WhatsappContactInclude include() {
    return WhatsappContactInclude._();
  }

  static WhatsappContactIncludeList includeList({
    _i1.WhereExpressionBuilder<WhatsappContactTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WhatsappContactTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WhatsappContactTable>? orderByList,
    WhatsappContactInclude? include,
  }) {
    return WhatsappContactIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WhatsappContact.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WhatsappContact.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WhatsappContactImpl extends WhatsappContact {
  _WhatsappContactImpl({
    int? id,
    required String jid,
    String? name,
    String? phone,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          jid: jid,
          name: name,
          phone: phone,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [WhatsappContact]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WhatsappContact copyWith({
    Object? id = _Undefined,
    String? jid,
    Object? name = _Undefined,
    Object? phone = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WhatsappContact(
      id: id is int? ? id : this.id,
      jid: jid ?? this.jid,
      name: name is String? ? name : this.name,
      phone: phone is String? ? phone : this.phone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class WhatsappContactTable extends _i1.Table<int?> {
  WhatsappContactTable({super.tableRelation})
      : super(tableName: 'whatsapp_contact') {
    jid = _i1.ColumnString(
      'jid',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    phone = _i1.ColumnString(
      'phone',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _i1.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final _i1.ColumnString jid;

  late final _i1.ColumnString name;

  late final _i1.ColumnString phone;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        jid,
        name,
        phone,
        createdAt,
        updatedAt,
      ];
}

class WhatsappContactInclude extends _i1.IncludeObject {
  WhatsappContactInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WhatsappContact.t;
}

class WhatsappContactIncludeList extends _i1.IncludeList {
  WhatsappContactIncludeList._({
    _i1.WhereExpressionBuilder<WhatsappContactTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WhatsappContact.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WhatsappContact.t;
}

class WhatsappContactRepository {
  const WhatsappContactRepository._();

  /// Returns a list of [WhatsappContact]s matching the given query parameters.
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
  Future<List<WhatsappContact>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WhatsappContactTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WhatsappContactTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WhatsappContactTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<WhatsappContact>(
      where: where?.call(WhatsappContact.t),
      orderBy: orderBy?.call(WhatsappContact.t),
      orderByList: orderByList?.call(WhatsappContact.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [WhatsappContact] matching the given query parameters.
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
  Future<WhatsappContact?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WhatsappContactTable>? where,
    int? offset,
    _i1.OrderByBuilder<WhatsappContactTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WhatsappContactTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<WhatsappContact>(
      where: where?.call(WhatsappContact.t),
      orderBy: orderBy?.call(WhatsappContact.t),
      orderByList: orderByList?.call(WhatsappContact.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [WhatsappContact] by its [id] or null if no such row exists.
  Future<WhatsappContact?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<WhatsappContact>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [WhatsappContact]s in the list and returns the inserted rows.
  ///
  /// The returned [WhatsappContact]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<WhatsappContact>> insert(
    _i1.Session session,
    List<WhatsappContact> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<WhatsappContact>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [WhatsappContact] and returns the inserted row.
  ///
  /// The returned [WhatsappContact] will have its `id` field set.
  Future<WhatsappContact> insertRow(
    _i1.Session session,
    WhatsappContact row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WhatsappContact>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WhatsappContact]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WhatsappContact>> update(
    _i1.Session session,
    List<WhatsappContact> rows, {
    _i1.ColumnSelections<WhatsappContactTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WhatsappContact>(
      rows,
      columns: columns?.call(WhatsappContact.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WhatsappContact]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WhatsappContact> updateRow(
    _i1.Session session,
    WhatsappContact row, {
    _i1.ColumnSelections<WhatsappContactTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WhatsappContact>(
      row,
      columns: columns?.call(WhatsappContact.t),
      transaction: transaction,
    );
  }

  /// Deletes all [WhatsappContact]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WhatsappContact>> delete(
    _i1.Session session,
    List<WhatsappContact> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WhatsappContact>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WhatsappContact].
  Future<WhatsappContact> deleteRow(
    _i1.Session session,
    WhatsappContact row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WhatsappContact>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WhatsappContact>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WhatsappContactTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WhatsappContact>(
      where: where(WhatsappContact.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WhatsappContactTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WhatsappContact>(
      where: where?.call(WhatsappContact.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
