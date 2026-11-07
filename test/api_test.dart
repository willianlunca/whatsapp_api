import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:test/test.dart';
import 'package:whatsapp_api/src/api/router.dart';
import 'package:whatsapp_api/src/providers/mock_provider.dart';
import 'package:whatsapp_api/src/session_manager.dart';
import 'package:whatsapp_api/src/webhooks.dart';

void main() {
  const token = 't0k3n';
  late Handler handler;

  setUp(() {
    final manager = SessionManager(
      providerFactory: (id, kind) =>
          MockProvider(id, autoConnectDelay: const Duration(milliseconds: 10)),
    );
    handler = buildHandler(
      manager: manager,
      webhooks: WebhookDispatcher(manager),
      token: token,
    );
  });

  Future<Response> call(String method, String path,
      {Object? body, bool auth = true}) async {
    return handler(Request(
      method,
      Uri.parse('http://localhost$path'),
      headers: {if (auth) 'authorization': 'Bearer $token'},
      body: body == null ? null : jsonEncode(body),
    ));
  }

  Future<dynamic> json(Response r) async => jsonDecode(await r.readAsString());

  test('health é público; o resto exige token', () async {
    expect((await call('GET', '/health', auth: false)).statusCode, 200);
    expect((await call('GET', '/v1/sessions', auth: false)).statusCode, 401);
  });

  test('fluxo: criar sessão, QR, conectar, enviar e receber', () async {
    var res = await call('POST', '/v1/sessions', body: {'id': 'main'});
    expect(res.statusCode, 201);

    res = await call('GET', '/v1/sessions/main/qr');
    expect(res.statusCode, 200);

    await Future<void>.delayed(const Duration(milliseconds: 100));
    res = await call('GET', '/v1/sessions/main');
    expect((await json(res))['status'], 'connected');

    res = await call('POST', '/v1/sessions/main/messages',
        body: {'to': '+55 43 99999-0000', 'text': 'olá'});
    expect(res.statusCode, 201);

    res = await call('POST', '/v1/sessions/main/simulate',
        body: {'from': '554399990000', 'text': 'oi!'});
    expect(res.statusCode, 201);

    await Future<void>.delayed(const Duration(milliseconds: 20));
    res = await call(
        'GET', '/v1/sessions/main/messages?chatId=554399990000@s.whatsapp.net');
    final msgs = await json(res) as List;
    expect(msgs.map((m) => m['body']), ['olá', 'oi!']);

    res = await call('GET', '/v1/sessions/main/chats');
    expect((await json(res) as List).length, 1);
  });

  test('validações', () async {
    expect((await call('POST', '/v1/sessions', body: {'id': 'a b'})).statusCode,
        400);
    expect((await call('GET', '/v1/sessions/nao-existe')).statusCode, 404);
    await call('POST', '/v1/sessions', body: {'id': 'x'});
    expect((await call('POST', '/v1/sessions', body: {'id': 'x'})).statusCode,
        409);
    // ainda não conectada
    final r = await call('POST', '/v1/sessions/x/messages',
        body: {'to': '5543999990000', 'text': 'oi'});
    expect(r.statusCode, 409);
  });
}
