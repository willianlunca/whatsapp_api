import 'dart:convert';
import 'dart:io';

import 'package:serverpod/serverpod.dart';
import 'package:whatsapp_api_server/src/services/whatsapp_message_service.dart';

class WhatsappWebhookRoute extends Route {
  @override
  Future<bool> handleCall(Session session, HttpRequest request) async {
    request.response.headers.contentType = ContentType.json;

    Future<bool> respond(int status, Map<String, dynamic> body) async {
      request.response.statusCode = status;
      request.response.write(jsonEncode(body));
      await request.response.close();
      return true;
    }

    if (request.method != 'POST') {
      return respond(HttpStatus.methodNotAllowed, {
        'success': false,
        'error': 'Método não permitido',
      });
    }

    final expectedToken = Platform.environment['WHATSAPP_WEBHOOK_TOKEN'];

    if (expectedToken == null || expectedToken.isEmpty) {
      return respond(HttpStatus.serviceUnavailable, {
        'success': false,
        'error': 'Webhook não configurado',
      });
    }

    final authorization =
        request.headers.value(HttpHeaders.authorizationHeader);

    if (authorization != 'Bearer $expectedToken') {
      return respond(HttpStatus.unauthorized, {
        'success': false,
        'error': 'Não autorizado',
      });
    }

    try {
      final body = await utf8.decoder.bind(request).join();
      final data = jsonDecode(body);

      if (data is! Map<String, dynamic>) {
        throw const FormatException('JSON deve ser um objeto');
      }

      final inserted = await WhatsappMessageService.process(session, data);

      session.log(
        inserted
            ? 'Mensagem WhatsApp armazenada'
            : 'Mensagem WhatsApp duplicada',
      );

      return respond(HttpStatus.ok, {
        'success': true,
        'inserted': inserted,
        'message': inserted
            ? 'Mensagem armazenada no PostgreSQL'
            : 'Mensagem já existente',
      });
    } on FormatException catch (e) {
      return respond(HttpStatus.badRequest, {
        'success': false,
        'error': e.message,
      });
    } catch (e, stackTrace) {
      session.log(
        'Erro ao persistir mensagem WhatsApp: $e\n$stackTrace',
        level: LogLevel.error,
      );

      return respond(HttpStatus.internalServerError, {
        'success': false,
        'error': 'Erro interno ao armazenar mensagem',
      });
    }
  }
}
