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

abstract class WhatsappContact implements _i1.SerializableModel {
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String jid;

  String? name;

  String? phone;

  DateTime createdAt;

  DateTime updatedAt;

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
