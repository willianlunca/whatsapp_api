/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

abstract class WhatsappMessage implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int conversationId;

  String whatsappMessageId;

  String senderJid;

  bool fromMe;

  String content;

  DateTime timestamp;

  DateTime createdAt;

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
