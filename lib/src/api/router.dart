import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../errors.dart';
import '../providers/mock_provider.dart';
import '../providers/whatsapp_provider.dart';
import '../session_manager.dart';
import '../webhooks.dart';
import 'http_utils.dart';

final _idRe = RegExp(r'^[a-zA-Z0-9_-]{1,40}$');

/// Aceita um JID completo ou só o telefone (vira `<digitos>@s.whatsapp.net`).
String normalizeChatId(String to) {
  if (to.contains('@')) return to;
  final digits = to.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) throw ApiException(400, '"to" inválido');
  return '$digits@s.whatsapp.net';
}

Handler buildHandler({
  required SessionManager manager,
  required WebhookDispatcher webhooks,
  required String token,
}) {
  final r = Router();

  Map<String, dynamic> sessionJson(WhatsAppProvider p) =>
      {'id': p.sessionId, 'provider': p.kind, 'status': p.status.name};

  WhatsAppProvider need(String id) =>
      manager.get(id) ?? (throw ApiException(404, 'sessão não encontrada'));

  r.get('/health', (Request _) => jsonResponse({'ok': true}));

  // ---- Sessões -----------------------------------------------------------
  r.get('/v1/sessions',
      (Request _) => jsonResponse(manager.list().map(sessionJson).toList()));

  r.post('/v1/sessions', (Request req) async {
    final b = await readJson(req);
    final id = b['id'];
    if (id is! String || !_idRe.hasMatch(id)) {
      throw ApiException(400, '"id" obrigatório (letras, números, _ e -)');
    }
    final k = b['provider'];
    final p = await manager.create(id, k is String ? k : 'mock');
    return jsonResponse(sessionJson(p), status: 201);
  });

  r.get('/v1/sessions/<id>',
      (Request _, String id) => jsonResponse(sessionJson(need(id))));

  r.delete('/v1/sessions/<id>', (Request _, String id) async {
    await manager.delete(id);
    return jsonResponse({'ok': true});
  });

  r.get('/v1/sessions/<id>/qr', (Request _, String id) {
    final qr = need(id).qr;
    if (qr == null) throw ApiException(404, 'sem QR (já conectada ou parada)');
    return jsonResponse({'qr': qr});
  });

  // ---- Mensagens ---------------------------------------------------------
  r.post('/v1/sessions/<id>/messages', (Request req, String id) async {
    final p = need(id);
    final b = await readJson(req);
    final to = b['to'], text = b['text'];
    if (to is! String || text is! String || text.isEmpty) {
      throw ApiException(400, 'informe "to" e "text"');
    }
    final m = await p.sendText(normalizeChatId(to), text);
    return jsonResponse(m.toJson(), status: 201);
  });

  r.get('/v1/sessions/<id>/messages', (Request req, String id) {
    need(id);
    final chatId = req.url.queryParameters['chatId'];
    if (chatId == null || chatId.isEmpty) {
      throw ApiException(400, 'informe ?chatId=');
    }
    final limit =
        (int.tryParse(req.url.queryParameters['limit'] ?? '') ?? 50)
            .clamp(1, 200);
    final msgs = manager.store.list(id, chatId, limit: limit);
    return jsonResponse(msgs.map((m) => m.toJson()).toList());
  });

  r.get('/v1/sessions/<id>/chats', (Request _, String id) {
    need(id);
    return jsonResponse(manager.store.chats(id));
  });

  // Só para o provedor simulado: injeta uma mensagem recebida.
  r.post('/v1/sessions/<id>/simulate', (Request req, String id) async {
    final p = need(id);
    if (p is! MockProvider) {
      throw ApiException(400, 'disponível apenas no provedor mock');
    }
    final b = await readJson(req);
    final from = b['from'], text = b['text'];
    if (from is! String || text is! String) {
      throw ApiException(400, 'informe "from" e "text"');
    }
    final pushName = b['pushName'];
    final m = p.simulateIncoming(normalizeChatId(from), text,
        pushName: pushName is String ? pushName : null);
    return jsonResponse(m.toJson(), status: 201);
  });

  // ---- Webhooks ----------------------------------------------------------
  r.get('/v1/webhooks',
      (Request _) => jsonResponse(webhooks.list().map((h) => h.toJson()).toList()));

  r.post('/v1/webhooks', (Request req) async {
    final b = await readJson(req);
    final url = b['url'], secret = b['secret'];
    if (url is! String) throw ApiException(400, '"url" obrigatória');
    final h = webhooks.add(url, secret: secret is String ? secret : null);
    return jsonResponse(h.toJson(), status: 201);
  });

  r.delete('/v1/webhooks/<id>', (Request _, String id) {
    if (!webhooks.remove(id)) throw ApiException(404, 'webhook não encontrado');
    return jsonResponse({'ok': true});
  });

  // ---- WebSocket: eventos em tempo real ----------------------------------
  r.get('/v1/ws', (Request req) {
    final sid = req.url.queryParameters['sessionId'];
    return webSocketHandler((WebSocketChannel ch, String? _) {
      final sub = manager.events
          .where((e) => sid == null || e.sessionId == sid)
          .listen((e) => ch.sink.add(jsonEncode(e.toJson())));
      ch.stream.listen((_) {}, onDone: sub.cancel, onError: (_) => sub.cancel());
    })(req);
  });

  return const Pipeline()
      .addMiddleware(safeLogMiddleware())
      .addMiddleware(errorMiddleware())
      .addMiddleware(authMiddleware(token))
      .addHandler(r.call);
}
