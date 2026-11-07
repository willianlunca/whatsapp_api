import 'dart:io';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:whatsapp_api/src/api/router.dart';
import 'package:whatsapp_api/src/config.dart';
import 'package:whatsapp_api/src/session_manager.dart';
import 'package:whatsapp_api/src/webhooks.dart';

Future<void> main() async {
  final cfg = Config.fromEnv();
  final manager = SessionManager();
  final webhooks = WebhookDispatcher(manager);

  final url = cfg.webhookUrl;
  if (url != null && url.isNotEmpty) {
    webhooks.add(url, secret: cfg.webhookSecret);
  }

  final handler =
      buildHandler(manager: manager, webhooks: webhooks, token: cfg.token);
  final server = await shelf_io.serve(handler, InternetAddress.anyIPv4, cfg.port);

  print('whatsapp_api no ar em http://localhost:${server.port}');
  if (cfg.tokenGenerated) {
    print('API_TOKEN não definido; token temporário desta execução: ${cfg.token}');
  }

  ProcessSignal.sigint.watch().listen((_) async {
    await webhooks.close();
    await server.close(force: true);
    exit(0);
  });
}
