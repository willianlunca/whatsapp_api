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

abstract class WhatsappConversation
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  WhatsappConversation._({
    this.id,
    required this.contactId,
    required this.status,
    this.lastMessageAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WhatsappConversation({
    int? id,
    required int contactId,
    required String status,
    DateTime? lastMessageAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _WhatsappConversationImpl;

  factory WhatsappConversation.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return WhatsappConversation(
      id: jsonSerialization['id'] as int?,
      contactId: jsonSerialization['contactId'] as int,
      status: jsonSerialization['status'] as String,
      lastMessageAt: jsonSerialization['lastMessageAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageAt']),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  static final t = WhatsappConversationTable();

  static const db = WhatsappConversationRepository._();

  @override
  int? id;

  int contactId;

  String status;

  DateTime? lastMessageAt;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [WhatsappConversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WhatsappConversation copyWith({
    int? id,
    int? contactId,
    String? status,
    DateTime? lastMessageAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'contactId': contactId,
      'status': status,
      if (lastMessageAt != null) 'lastMessageAt': lastMessageAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'contactId': contactId,
      'status': status,
      if (lastMessageAt != null) 'lastMessageAt': lastMessageAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  static WhatsappConversationInclude include() {
    return WhatsappConversationInclude._();
  }

  static WhatsappConversationIncludeList includeList({
    _i1.WhereExpressionBuilder<WhatsappConversationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WhatsappConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WhatsappConversationTable>? orderByList,
    WhatsappConversationInclude? include,
  }) {
    return WhatsappConversationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WhatsappConversation.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WhatsappConversation.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WhatsappConversationImpl extends WhatsappConversation {
  _WhatsappConversationImpl({
    int? id,
    required int contactId,
    required String status,
    DateTime? lastMessageAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
          id: id,
          contactId: contactId,
          status: status,
          lastMessageAt: lastMessageAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
        );

  /// Returns a shallow copy of this [WhatsappConversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WhatsappConversation copyWith({
    Object? id = _Undefined,
    int? contactId,
    String? status,
    Object? lastMessageAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WhatsappConversation(
      id: id is int? ? id : this.id,
      contactId: contactId ?? this.contactId,
      status: status ?? this.status,
      lastMessageAt:
          lastMessageAt is DateTime? ? lastMessageAt : this.lastMessageAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class WhatsappConversationTable extends _i1.Table<int?> {
  WhatsappConversationTable({super.tableRelation})
      : super(tableName: 'whatsapp_conversation') {
    contactId = _i1.ColumnInt(
      'contactId',
      this,
    );
    status = _i1.ColumnString(
      'status',
      this,
    );
    lastMessageAt = _i1.ColumnDateTime(
      'lastMessageAt',
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

  late final _i1.ColumnInt contactId;

  late final _i1.ColumnString status;

  late final _i1.ColumnDateTime lastMessageAt;

  late final _i1.ColumnDateTime createdAt;

  late final _i1.ColumnDateTime updatedAt;

  @override
  List<_i1.Column> get columns => [
        id,
        contactId,
        status,
        lastMessageAt,
        createdAt,
        updatedAt,
      ];
}

class WhatsappConversationInclude extends _i1.IncludeObject {
  WhatsappConversationInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WhatsappConversation.t;
}

class WhatsappConversationIncludeList extends _i1.IncludeList {
  WhatsappConversationIncludeList._({
    _i1.WhereExpressionBuilder<WhatsappConversationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WhatsappConversation.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WhatsappConversation.t;
}

class WhatsappConversationRepository {
  const WhatsappConversationRepository._();

  /// Returns a list of [WhatsappConversation]s matching the given query parameters.
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
  Future<List<WhatsappConversation>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WhatsappConversationTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WhatsappConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WhatsappConversationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<WhatsappConversation>(
      where: where?.call(WhatsappConversation.t),
      orderBy: orderBy?.call(WhatsappConversation.t),
      orderByList: orderByList?.call(WhatsappConversation.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [WhatsappConversation] matching the given query parameters.
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
  Future<WhatsappConversation?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WhatsappConversationTable>? where,
    int? offset,
    _i1.OrderByBuilder<WhatsappConversationTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WhatsappConversationTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<WhatsappConversation>(
      where: where?.call(WhatsappConversation.t),
      orderBy: orderBy?.call(WhatsappConversation.t),
      orderByList: orderByList?.call(WhatsappConversation.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [WhatsappConversation] by its [id] or null if no such row exists.
  Future<WhatsappConversation?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<WhatsappConversation>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [WhatsappConversation]s in the list and returns the inserted rows.
  ///
  /// The returned [WhatsappConversation]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<WhatsappConversation>> insert(
    _i1.Session session,
    List<WhatsappConversation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<WhatsappConversation>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [WhatsappConversation] and returns the inserted row.
  ///
  /// The returned [WhatsappConversation] will have its `id` field set.
  Future<WhatsappConversation> insertRow(
    _i1.Session session,
    WhatsappConversation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WhatsappConversation>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WhatsappConversation]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WhatsappConversation>> update(
    _i1.Session session,
    List<WhatsappConversation> rows, {
    _i1.ColumnSelections<WhatsappConversationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WhatsappConversation>(
      rows,
      columns: columns?.call(WhatsappConversation.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WhatsappConversation]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WhatsappConversation> updateRow(
    _i1.Session session,
    WhatsappConversation row, {
    _i1.ColumnSelections<WhatsappConversationTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WhatsappConversation>(
      row,
      columns: columns?.call(WhatsappConversation.t),
      transaction: transaction,
    );
  }

  /// Deletes all [WhatsappConversation]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WhatsappConversation>> delete(
    _i1.Session session,
    List<WhatsappConversation> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WhatsappConversation>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WhatsappConversation].
  Future<WhatsappConversation> deleteRow(
    _i1.Session session,
    WhatsappConversation row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WhatsappConversation>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WhatsappConversation>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WhatsappConversationTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WhatsappConversation>(
      where: where(WhatsappConversation.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WhatsappConversationTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WhatsappConversation>(
      where: where?.call(WhatsappConversation.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
