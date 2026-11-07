enum SessionStatus { stopped, qr, connecting, connected }

class WaMessage {
  WaMessage({
    required this.id,
    required this.sessionId,
    required this.chatId,
    required this.fromMe,
    required this.body,
    required this.timestamp,
    this.type = 'text',
    this.pushName,
  });

  final String id;
  final String sessionId;

  /// JID do chat, ex.: `5543999999999@s.whatsapp.net` ou `1234-5678@g.us`.
  final String chatId;
  final bool fromMe;
  final String body;
  final String type;
  final String? pushName;
  final DateTime timestamp;

  Map<String, dynamic> toJson() => {
        'id': id,
        'sessionId': sessionId,
        'chatId': chatId,
        'fromMe': fromMe,
        'type': type,
        'body': body,
        if (pushName != null) 'pushName': pushName,
        'timestamp': timestamp.toUtc().toIso8601String(),
      };
}

/// Evento emitido por um provedor: `qr`, `status` ou `message`.
class WaEvent {
  WaEvent(this.type, this.sessionId, this.data, {this.message});

  final String type;
  final String sessionId;
  final Map<String, dynamic> data;

  /// Preenchido nos eventos `message`, para o armazenamento.
  final WaMessage? message;

  Map<String, dynamic> toJson() => {
        'event': type,
        'sessionId': sessionId,
        'data': data,
        'ts': DateTime.now().toUtc().toIso8601String(),
      };
}
