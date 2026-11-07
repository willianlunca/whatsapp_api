import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:developer' as developer;

class WhatsappMediaService {
  static const int maxMediaBytes = 50 * 1024 * 1024;

  static Future<String> transferToTalk({
    required String messageId,
    required String mediaType,
    required String mimeType,
    required String fileName,
  }) async {
    final baileysUrl = _env('BAILEYS_URL');
    final baileysToken = _env('BAILEYS_API_TOKEN');

    final nextcloudUrl = _env('NEXTCLOUD_URL');
    final nextcloudUser = _env('NEXTCLOUD_USER');
    final nextcloudPassword = _env('NEXTCLOUD_APP_PASSWORD');
    final roomToken = _env('NEXTCLOUD_TALK_ROOM_TOKEN');

    final safeId = _safeName(messageId);
    final safeFileName = _safeName(fileName);

    final remotePath = '/WhatsApp/$safeId-$safeFileName';

    developer.log(
      '[MEDIA] Buscando arquivo no Baileys: $messageId',
      name: 'WhatsappMediaService',
    );

    final media = await _download(
      baseUrl: baileysUrl,
      token: baileysToken,
      messageId: messageId,
    );

    developer.log(
      '[MEDIA] Download concluído: ${media.length} bytes',
      name: 'WhatsappMediaService',
    );

    final auth = 'Basic ${base64Encode(
      utf8.encode('$nextcloudUser:$nextcloudPassword'),
    )}';

    final webdavUri = Uri.parse(nextcloudUrl).replace(
      pathSegments: [
        ...Uri.parse(nextcloudUrl).pathSegments.where(
              (segment) => segment.isNotEmpty,
            ),
        'remote.php',
        'dav',
        'files',
        nextcloudUser,
        'WhatsApp',
        '$safeId-$safeFileName',
      ],
    );

    await _uploadWebdav(
      uri: webdavUri,
      authorization: auth,
      mimeType: mimeType,
      bytes: media,
    );

    developer.log(
      '[MEDIA] Upload WebDAV concluído: $remotePath',
      name: 'WhatsappMediaService',
    );

    await _shareWithTalk(
      nextcloudUrl: nextcloudUrl,
      authorization: auth,
      roomToken: roomToken,
      remotePath: remotePath,
    );

    developer.log(
      '[MEDIA] Arquivo compartilhado no Talk: $remotePath',
      name: 'WhatsappMediaService',
    );

    return remotePath;
  }

  static String _env(String key) {
    final value = Platform.environment[key]?.trim();

    if (value == null || value.isEmpty) {
      throw StateError('Variável de ambiente ausente: $key');
    }

    return value;
  }

  static String _safeName(String value) {
    final result = value
        .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_')
        .replaceAll(RegExp(r'^\.+'), '_');

    if (result.isEmpty || result.length > 180) {
      throw FormatException('Nome de arquivo inválido');
    }

    return result;
  }

  static Future<Uint8List> _download({
    required String baseUrl,
    required String token,
    required String messageId,
  }) async {
    final base = Uri.parse(baseUrl);

    final uri = base.replace(
      pathSegments: [
        ...base.pathSegments.where((s) => s.isNotEmpty),
        'media',
        messageId,
      ],
    );

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);

    try {
      final request = await client.getUrl(uri);

      request.headers.set(
        HttpHeaders.authorizationHeader,
        'Bearer $token',
      );

      final response = await request.close();

      if (response.statusCode != HttpStatus.ok) {
        await response.drain<void>();
        throw HttpException(
          'Baileys retornou HTTP ${response.statusCode}',
          uri: uri,
        );
      }

      if (response.contentLength > maxMediaBytes) {
        throw StateError('Arquivo excede o limite de 50 MB');
      }

      final builder = BytesBuilder(copy: false);
      var received = 0;

      await for (final chunk in response) {
        received += chunk.length;

        if (received > maxMediaBytes) {
          throw StateError('Arquivo excede o limite de 50 MB');
        }

        builder.add(chunk);
      }

      if (received == 0) {
        throw StateError('Baileys retornou arquivo vazio');
      }

      return builder.takeBytes();
    } finally {
      client.close(force: true);
    }
  }

  static Future<void> _uploadWebdav({
    required Uri uri,
    required String authorization,
    required String mimeType,
    required Uint8List bytes,
  }) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);

    try {
      final request = await client.openUrl('PUT', uri);

      request.headers.set(
        HttpHeaders.authorizationHeader,
        authorization,
      );

      request.headers.set(
        HttpHeaders.contentTypeHeader,
        mimeType,
      );

      request.contentLength = bytes.length;
      request.add(bytes);

      final response = await request.close();
      final body = await utf8.decoder.bind(response).join();

      if (response.statusCode != HttpStatus.created &&
          response.statusCode != HttpStatus.noContent) {
        throw HttpException(
          'Falha no WebDAV: HTTP ${response.statusCode}: '
          '${_short(body)}',
          uri: uri,
        );
      }
    } finally {
      client.close(force: true);
    }
  }

  static Future<void> _shareWithTalk({
    required String nextcloudUrl,
    required String authorization,
    required String roomToken,
    required String remotePath,
  }) async {
    final base = Uri.parse(nextcloudUrl);

    final uri = base.replace(
      pathSegments: [
        ...base.pathSegments.where((s) => s.isNotEmpty),
        'ocs',
        'v2.php',
        'apps',
        'files_sharing',
        'api',
        'v1',
        'shares',
      ],
      queryParameters: {'format': 'json'},
    );

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);

    try {
      final request = await client.postUrl(uri);

      request.headers.set(
        HttpHeaders.authorizationHeader,
        authorization,
      );
      request.headers.set('OCS-APIRequest', 'true');
      request.headers.set(
        HttpHeaders.acceptHeader,
        'application/json',
      );

      request.headers.contentType = ContentType(
        'application',
        'x-www-form-urlencoded',
        charset: 'utf-8',
      );

      final form = {
        'path': remotePath,
        'shareType': '10',
        'shareWith': roomToken,
        'permissions': '1',
      };

      request.write(
        form.entries.map((entry) {
          return '${Uri.encodeQueryComponent(entry.key)}='
              '${Uri.encodeQueryComponent(entry.value)}';
        }).join('&'),
      );

      final response = await request.close();
      final body = await utf8.decoder.bind(response).join();

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Falha no compartilhamento OCS: '
          'HTTP ${response.statusCode}: ${_short(body)}',
          uri: uri,
        );
      }

      final decoded = jsonDecode(body);

      if (decoded is! Map ||
          decoded['ocs'] is! Map ||
          decoded['ocs']['meta'] is! Map) {
        throw FormatException('Resposta OCS inválida');
      }

      final meta = decoded['ocs']['meta'] as Map;
      final status = meta['status']?.toString().toLowerCase();
      final statusCode = int.tryParse(
        meta['statuscode']?.toString() ?? '',
      );

      if (status != 'ok' ||
          statusCode == null ||
          statusCode < 100 ||
          statusCode >= 300) {
        throw StateError(
          'Nextcloud recusou compartilhamento: '
          '${meta['message']} (OCS $statusCode)',
        );
      }
    } finally {
      client.close(force: true);
    }
  }

  static String _short(String value) {
    return value.length <= 500 ? value : value.substring(0, 500);
  }
}
