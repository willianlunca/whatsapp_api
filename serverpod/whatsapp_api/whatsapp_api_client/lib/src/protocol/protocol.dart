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
import 'greeting.dart' as _i2;
import 'whatsapp_contact.dart' as _i3;
import 'whatsapp_conversation.dart' as _i4;
import 'whatsapp_message.dart' as _i5;
export 'greeting.dart';
export 'whatsapp_contact.dart';
export 'whatsapp_conversation.dart';
export 'whatsapp_message.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.Greeting) {
      return _i2.Greeting.fromJson(data) as T;
    }
    if (t == _i3.WhatsappContact) {
      return _i3.WhatsappContact.fromJson(data) as T;
    }
    if (t == _i4.WhatsappConversation) {
      return _i4.WhatsappConversation.fromJson(data) as T;
    }
    if (t == _i5.WhatsappMessage) {
      return _i5.WhatsappMessage.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.Greeting?>()) {
      return (data != null ? _i2.Greeting.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.WhatsappContact?>()) {
      return (data != null ? _i3.WhatsappContact.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.WhatsappConversation?>()) {
      return (data != null ? _i4.WhatsappConversation.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.WhatsappMessage?>()) {
      return (data != null ? _i5.WhatsappMessage.fromJson(data) : null) as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i2.Greeting) {
      return 'Greeting';
    }
    if (data is _i3.WhatsappContact) {
      return 'WhatsappContact';
    }
    if (data is _i4.WhatsappConversation) {
      return 'WhatsappConversation';
    }
    if (data is _i5.WhatsappMessage) {
      return 'WhatsappMessage';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Greeting') {
      return deserialize<_i2.Greeting>(data['data']);
    }
    if (dataClassName == 'WhatsappContact') {
      return deserialize<_i3.WhatsappContact>(data['data']);
    }
    if (dataClassName == 'WhatsappConversation') {
      return deserialize<_i4.WhatsappConversation>(data['data']);
    }
    if (dataClassName == 'WhatsappMessage') {
      return deserialize<_i5.WhatsappMessage>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
