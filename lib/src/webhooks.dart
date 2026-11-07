import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import 'session_manager.dart';

class Webhook {
  Webhook(this.id, this.url, this.secret);

  final String id;
  final String url;
  final String? secret;

  Map<String, dynamic> toJson() => {'id': id, 'url': url};
}

/// Entrega cada evento por POST JSON nas URLs cadastradas. Se houver
/// `secret`, assina o corpo com HMAC-SHA256 no header `X-Signature`
/// (formato `sha256=<hex>`).
class WebhookDispatcher {
  WebhookDispatcher(SessionManager manager, {http.Client? client})
      : _client = client ?? http.Client() {
    _sub = manager.events.listen(_dispatch);
  }

  final http.Client _client;
  late final StreamSubscription<dynamic> _sub;
  final _hooks = <String, Webhook>{};
  int _seq = 0;

  List<Webhook> list() => _hooks.values.toList();

  Webhook add(String url, {String? secret}) {
    final uri = Uri.tryParse(url);
    if (uri == null || !(uri.isScheme('http') || uri.isScheme('https'))) {
      throw FormatException('url inválida: $url');
    }
    final h = Webhook('wh${++_seq}', url, secret);
    _hooks[h.id] = h;
    return h;
  }

  bool remove(String id) => _hooks.remove(id) != null;

  Future<void> _dispatch(dynamic event) async {
    final body = jsonEncode(event.toJson());
    for (final h in list()) {
      final headers = {'content-type': 'application/json'};
      final secret = h.secret;
      if (secret != null && secret.isNotEmpty) {
        final sig = Hmac(sha256, utf8.encode(secret))
            .convert(utf8.encode(body))
            .toString();
        headers['x-signature'] = 'sha256=$sig';
      }
      try {
        await _client
            .post(Uri.parse(h.url), headers: headers, body: body)
            .timeout(const Duration(seconds: 5));
      } catch (_) {
        // Falha de entrega não derruba a API. Fila com retry fica para depois.
      }
    }
  }

  Future<void> close() async {
    await _sub.cancel();
    _client.close();
  }
}
