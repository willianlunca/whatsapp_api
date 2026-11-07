import 'dart:convert';
import 'dart:io';

class NextcloudTalkService {
  static Future<void> sendMessage({
    required String message,
  }) async {
    final baseUrl = Platform.environment['NEXTCLOUD_URL'];
    final username = Platform.environment['NEXTCLOUD_USER'];
    final password = Platform.environment['NEXTCLOUD_APP_PASSWORD'];
    final roomToken = Platform.environment['NEXTCLOUD_TALK_ROOM_TOKEN'];

    if ([baseUrl, username, password, roomToken]
        .any((value) => value == null || value.isEmpty)) {
      throw StateError('Configuração do Nextcloud Talk incompleta');
    }

    final uri = Uri.parse(
      '${baseUrl!.replaceAll(RegExp(r"/+$"), "")}'
      '/ocs/v2.php/apps/spreed/api/v1/chat/$roomToken',
    );

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);

    try {
      final request = await client.postUrl(uri);

      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Basic ${base64Encode(utf8.encode('$username:$password'))}',
      );
      request.headers.set('OCS-APIRequest', 'true');
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      request.headers.contentType = ContentType(
        'application',
        'x-www-form-urlencoded',
        charset: 'utf-8',
      );

      request.write(
        'message=${Uri.encodeQueryComponent(message)}',
      );

      final response = await request.close().timeout(
            const Duration(seconds: 15),
          );

      final body = await utf8.decoder.bind(response).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Erro HTTP ${response.statusCode} no Talk: $body',
        );
      }

      final decoded = jsonDecode(body);

      if (decoded is! Map ||
          decoded['ocs'] is! Map ||
          decoded['ocs']['meta'] is! Map ||
          decoded['ocs']['meta']['status'] != 'ok') {
        throw FormatException(
          'Resposta inesperada do Nextcloud Talk: $body',
        );
      }
    } finally {
      client.close(force: true);
    }
  }
}
