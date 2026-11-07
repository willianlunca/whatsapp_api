import 'dart:async';

import 'errors.dart';
import 'message_store.dart';
import 'models.dart';
import 'providers/whatsapp_provider.dart';

typedef ProviderFactory = WhatsAppProvider Function(String id, String kind);

/// Guarda as sessões ativas, grava as mensagens e republica os eventos
/// de todos os provedores num único stream.
class SessionManager {
  SessionManager({ProviderFactory? providerFactory, MessageStore? store})
      : providerFactory = providerFactory ?? createProvider,
        store = store ?? MessageStore();

  final ProviderFactory providerFactory;
  final MessageStore store;

  final _sessions = <String, WhatsAppProvider>{};
  final _subs = <String, StreamSubscription<WaEvent>>{};
  final _events = StreamController<WaEvent>.broadcast();

  Stream<WaEvent> get events => _events.stream;

  List<WhatsAppProvider> list() => _sessions.values.toList();

  WhatsAppProvider? get(String id) => _sessions[id];

  Future<WhatsAppProvider> create(String id, String kind) async {
    if (_sessions.containsKey(id)) {
      throw ApiException(409, 'sessão já existe');
    }
    final p = providerFactory(id, kind);
    _sessions[id] = p;
    _subs[id] = p.events.listen(_onEvent);
    await p.start();
    return p;
  }

  Future<void> delete(String id) async {
    final p = _sessions.remove(id);
    if (p == null) throw ApiException(404, 'sessão não encontrada');
    await _subs.remove(id)?.cancel();
    await p.stop();
    store.clear(id);
  }

  void _onEvent(WaEvent e) {
    final m = e.message;
    if (m != null) store.add(m);
    _events.add(e);
  }
}
