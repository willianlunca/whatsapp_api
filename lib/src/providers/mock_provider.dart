import 'dart:async';

import '../errors.dart';
import '../models.dart';
import 'whatsapp_provider.dart';

/// Provedor simulado: gera um QR falso, "conecta" sozinho e permite injetar
/// mensagens recebidas. Serve para validar a API e a integração (Nextcloud
/// Talk) antes de existir um motor real de WhatsApp.
class MockProvider implements WhatsAppProvider {
  MockProvider(this.sessionId,
      {this.autoConnectDelay = const Duration(seconds: 2)});

  @override
  final String sessionId;
  final Duration autoConnectDelay;

  @override
  String get kind => 'mock';

  final _ctrl = StreamController<WaEvent>.broadcast();
  SessionStatus _status = SessionStatus.stopped;
  String? _qr;
  Timer? _timer;
  int _counter = 0;

  @override
  SessionStatus get status => _status;

  @override
  String? get qr => _qr;

  @override
  Stream<WaEvent> get events => _ctrl.stream;

  void _emit(WaEvent e) {
    if (!_ctrl.isClosed) _ctrl.add(e);
  }

  void _setStatus(SessionStatus s) {
    _status = s;
    _emit(WaEvent('status', sessionId, {'status': s.name}));
  }

  @override
  Future<void> start() async {
    _qr = 'mock-qr:$sessionId:${DateTime.now().millisecondsSinceEpoch}';
    _setStatus(SessionStatus.qr);
    _emit(WaEvent('qr', sessionId, {'qr': _qr}));
    _timer = Timer(autoConnectDelay, () {
      _qr = null;
      _setStatus(SessionStatus.connected);
    });
  }

  @override
  Future<void> stop() async {
    _timer?.cancel();
    _qr = null;
    _setStatus(SessionStatus.stopped);
    await _ctrl.close();
  }

  @override
  Future<WaMessage> sendText(String chatId, String text) async {
    if (_status != SessionStatus.connected) {
      throw ApiException(409, 'sessão não conectada');
    }
    final m = WaMessage(
      id: 'mock-${_counter++}',
      sessionId: sessionId,
      chatId: chatId,
      fromMe: true,
      body: text,
      timestamp: DateTime.now(),
    );
    _emit(WaEvent('message', sessionId, m.toJson(), message: m));
    return m;
  }

  /// Simula uma mensagem recebida de [chatId].
  WaMessage simulateIncoming(String chatId, String text, {String? pushName}) {
    if (_status != SessionStatus.connected) {
      throw ApiException(409, 'sessão não conectada');
    }
    final m = WaMessage(
      id: 'mock-in-${_counter++}',
      sessionId: sessionId,
      chatId: chatId,
      fromMe: false,
      body: text,
      pushName: pushName,
      timestamp: DateTime.now(),
    );
    _emit(WaEvent('message', sessionId, m.toJson(), message: m));
    return m;
  }
}
