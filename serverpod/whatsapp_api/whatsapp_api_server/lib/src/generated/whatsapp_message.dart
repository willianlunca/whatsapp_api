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

abstract class WhatsappMessage
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  WhatsappMessage._({
    this.id,
    required this.conversationId,
    required this.whatsappMessageId,
    required this.senderJid,
    required this.fromMe,
    required this.content,
    required this.timestamp,
    required this.createdAt,
  });

  factory WhatsappMessage({
    int? id,
    required int conversationId,
    required String whatsappMessageId,
    required String senderJid,
    required bool fromMe,
    required String content,
    required DateTime timestamp,
    required DateTime createdAt,
  }) = _WhatsappMessageImpl;

  factory WhatsappMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return WhatsappMessage(
      id: jsonSerialization['id'] as int?,
      conversationId: jsonSerialization['conversationId'] as int,
      whatsappMessageId: jsonSerialization['whatsappMessageId'] as String,
      senderJid: jsonSerialization['senderJid'] as String,
      fromMe: jsonSerialization['fromMe'] as bool,
      content: jsonSerialization['content'] as String,
      timestamp:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['timestamp']),
      createdAt:
          _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = WhatsappMessageTable();

  static const db = WhatsappMessageRepository._();

  @override
  int? id;

  int conversationId;

  String whatsappMessageId;

  String senderJid;

  bool fromMe;

  String content;

  DateTime timestamp;

  DateTime createdAt;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [WhatsappMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  WhatsappMessage copyWith({
    int? id,
    int? conversationId,
    String? whatsappMessageId,
    String? senderJid,
    bool? fromMe,
    String? content,
    DateTime? timestamp,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'conversationId': conversationId,
      'whatsappMessageId': whatsappMessageId,
      'senderJid': senderJid,
      'fromMe': fromMe,
      'content': content,
      'timestamp': timestamp.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'conversationId': conversationId,
      'whatsappMessageId': whatsappMessageId,
      'senderJid': senderJid,
      'fromMe': fromMe,
      'content': content,
      'timestamp': timestamp.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  static WhatsappMessageInclude include() {
    return WhatsappMessageInclude._();
  }

  static WhatsappMessageIncludeList includeList({
    _i1.WhereExpressionBuilder<WhatsappMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WhatsappMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WhatsappMessageTable>? orderByList,
    WhatsappMessageInclude? include,
  }) {
    return WhatsappMessageIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(WhatsappMessage.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(WhatsappMessage.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WhatsappMessageImpl extends WhatsappMessage {
  _WhatsappMessageImpl({
    int? id,
    required int conversationId,
    required String whatsappMessageId,
    required String senderJid,
    required bool fromMe,
    required String content,
    required DateTime timestamp,
    required DateTime createdAt,
  }) : super._(
          id: id,
          conversationId: conversationId,
          whatsappMessageId: whatsappMessageId,
          senderJid: senderJid,
          fromMe: fromMe,
          content: content,
          timestamp: timestamp,
          createdAt: createdAt,
        );

  /// Returns a shallow copy of this [WhatsappMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  WhatsappMessage copyWith({
    Object? id = _Undefined,
    int? conversationId,
    String? whatsappMessageId,
    String? senderJid,
    bool? fromMe,
    String? content,
    DateTime? timestamp,
    DateTime? createdAt,
  }) {
    return WhatsappMessage(
      id: id is int? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      whatsappMessageId: whatsappMessageId ?? this.whatsappMessageId,
      senderJid: senderJid ?? this.senderJid,
      fromMe: fromMe ?? this.fromMe,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class WhatsappMessageTable extends _i1.Table<int?> {
  WhatsappMessageTable({super.tableRelation})
      : super(tableName: 'whatsapp_message') {
    conversationId = _i1.ColumnInt(
      'conversationId',
      this,
    );
    whatsappMessageId = _i1.ColumnString(
      'whatsappMessageId',
      this,
    );
    senderJid = _i1.ColumnString(
      'senderJid',
      this,
    );
    fromMe = _i1.ColumnBool(
      'fromMe',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    timestamp = _i1.ColumnDateTime(
      'timestamp',
      this,
    );
    createdAt = _i1.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final _i1.ColumnInt conversationId;

  late final _i1.ColumnString whatsappMessageId;

  late final _i1.ColumnString senderJid;

  late final _i1.ColumnBool fromMe;

  late final _i1.ColumnString content;

  late final _i1.ColumnDateTime timestamp;

  late final _i1.ColumnDateTime createdAt;

  @override
  List<_i1.Column> get columns => [
        id,
        conversationId,
        whatsappMessageId,
        senderJid,
        fromMe,
        content,
        timestamp,
        createdAt,
      ];
}

class WhatsappMessageInclude extends _i1.IncludeObject {
  WhatsappMessageInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => WhatsappMessage.t;
}

class WhatsappMessageIncludeList extends _i1.IncludeList {
  WhatsappMessageIncludeList._({
    _i1.WhereExpressionBuilder<WhatsappMessageTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(WhatsappMessage.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => WhatsappMessage.t;
}

class WhatsappMessageRepository {
  const WhatsappMessageRepository._();

  /// Returns a list of [WhatsappMessage]s matching the given query parameters.
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
  Future<List<WhatsappMessage>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WhatsappMessageTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<WhatsappMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WhatsappMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.find<WhatsappMessage>(
      where: where?.call(WhatsappMessage.t),
      orderBy: orderBy?.call(WhatsappMessage.t),
      orderByList: orderByList?.call(WhatsappMessage.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Returns the first matching [WhatsappMessage] matching the given query parameters.
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
  Future<WhatsappMessage?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WhatsappMessageTable>? where,
    int? offset,
    _i1.OrderByBuilder<WhatsappMessageTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<WhatsappMessageTable>? orderByList,
    _i1.Transaction? transaction,
  }) async {
    return session.db.findFirstRow<WhatsappMessage>(
      where: where?.call(WhatsappMessage.t),
      orderBy: orderBy?.call(WhatsappMessage.t),
      orderByList: orderByList?.call(WhatsappMessage.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
    );
  }

  /// Finds a single [WhatsappMessage] by its [id] or null if no such row exists.
  Future<WhatsappMessage?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.findById<WhatsappMessage>(
      id,
      transaction: transaction,
    );
  }

  /// Inserts all [WhatsappMessage]s in the list and returns the inserted rows.
  ///
  /// The returned [WhatsappMessage]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<WhatsappMessage>> insert(
    _i1.Session session,
    List<WhatsappMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<WhatsappMessage>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [WhatsappMessage] and returns the inserted row.
  ///
  /// The returned [WhatsappMessage] will have its `id` field set.
  Future<WhatsappMessage> insertRow(
    _i1.Session session,
    WhatsappMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<WhatsappMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [WhatsappMessage]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<WhatsappMessage>> update(
    _i1.Session session,
    List<WhatsappMessage> rows, {
    _i1.ColumnSelections<WhatsappMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<WhatsappMessage>(
      rows,
      columns: columns?.call(WhatsappMessage.t),
      transaction: transaction,
    );
  }

  /// Updates a single [WhatsappMessage]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<WhatsappMessage> updateRow(
    _i1.Session session,
    WhatsappMessage row, {
    _i1.ColumnSelections<WhatsappMessageTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<WhatsappMessage>(
      row,
      columns: columns?.call(WhatsappMessage.t),
      transaction: transaction,
    );
  }

  /// Deletes all [WhatsappMessage]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<WhatsappMessage>> delete(
    _i1.Session session,
    List<WhatsappMessage> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<WhatsappMessage>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [WhatsappMessage].
  Future<WhatsappMessage> deleteRow(
    _i1.Session session,
    WhatsappMessage row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<WhatsappMessage>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<WhatsappMessage>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<WhatsappMessageTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<WhatsappMessage>(
      where: where(WhatsappMessage.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<WhatsappMessageTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<WhatsappMessage>(
      where: where?.call(WhatsappMessage.t),
      limit: limit,
      transaction: transaction,
    );
  }
}
