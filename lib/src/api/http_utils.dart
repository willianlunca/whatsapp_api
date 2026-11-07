import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../errors.dart';

Response jsonResponse(Object? body, {int status = 200}) => Response(
      status,
      body: jsonEncode(body),
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

Future<Map<String, dynamic>> readJson(Request req) async {
  final raw = await req.readAsString();
  if (raw.trim().isEmpty) return {};
  final d = jsonDecode(raw);
  if (d is! Map<String, dynamic>) {
    throw ApiException(400, 'o corpo deve ser um objeto JSON');
  }
  return d;
}

bool _safeEquals(String a, String b) {
  final x = utf8.encode(a), y = utf8.encode(b);
  var diff = x.length ^ y.length;
  for (var i = 0; i < x.length && i < y.length; i++) {
    diff |= x[i] ^ y[i];
  }
  return diff == 0;
}

/// Exige `Authorization: Bearer <token>`, `X-Api-Key` ou `?token=`
/// (esta última só para clientes WebSocket que não enviam headers).
Middleware authMiddleware(String token) => (inner) => (req) {
      if (req.url.path == 'health') return inner(req);
      final h = req.headers['authorization'];
      final provided = (h != null && h.startsWith('Bearer '))
          ? h.substring(7)
          : req.headers['x-api-key'] ?? req.url.queryParameters['token'];
      if (provided == null || !_safeEquals(provided, token)) {
        return jsonResponse({'error': 'não autorizado'}, status: 401);
      }
      return inner(req);
    };

Middleware errorMiddleware() => (inner) => (req) async {
      try {
        return await inner(req);
      } on ApiException catch (e) {
        return jsonResponse({'error': e.message}, status: e.status);
      } on FormatException catch (e) {
        return jsonResponse({'error': 'requisição inválida: ${e.message}'},
            status: 400);
      } catch (e) {
        print('erro interno: $e');
        return jsonResponse({'error': 'erro interno'}, status: 500);
      }
    };

/// Log simples sem a query string (ela pode conter o token do WebSocket).
Middleware safeLogMiddleware() => (inner) => (req) async {
      final res = await inner(req);
      print('${req.method} /${req.url.path} -> ${res.statusCode}');
      return res;
    };
