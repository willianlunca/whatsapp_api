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

abstract class WhatsappConversation implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int contactId;

  String status;

  DateTime? lastMessageAt;

  DateTime createdAt;

  DateTime updatedAt;

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
