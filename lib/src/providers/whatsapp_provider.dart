import '../errors.dart';
import '../models.dart';
import 'mock_provider.dart';

/// Contrato que qualquer "motor" de WhatsApp precisa cumprir.
///
/// O resto da API (REST, WebSocket, webhooks) só conhece esta interface.
/// Para plugar o protocolo real, basta implementar uma nova classe aqui
/// e registrá-la em [createProvider].
abstract class WhatsAppProvider {
  String get sessionId;

  /// Nome do tipo de provedor (`mock`, `native`, ...).
  String get kind;

  SessionStatus get status;

  /// QR code atual para parear, ou `null` se não houver.
  String? get qr;

  Stream<WaEvent> get events;

  Future<void> start();
  Future<void> stop();

  /// Envia texto e devolve a mensagem criada.
  Future<WaMessage> sendText(String chatId, String text);
}

WhatsAppProvider createProvider(String sessionId, String kind) {
  switch (kind) {
    case 'mock':
      return MockProvider(sessionId);
    default:
      throw ApiException(400, 'provedor desconhecido: $kind');
  }
}
