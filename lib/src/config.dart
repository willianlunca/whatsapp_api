import 'dart:io';
import 'dart:math';

class Config {
  Config({
    required this.port,
    required this.token,
    required this.tokenGenerated,
    this.webhookUrl,
    this.webhookSecret,
  });

  final int port;
  final String token;
  final bool tokenGenerated;
  final String? webhookUrl;
  final String? webhookSecret;

  /// Variáveis: PORT (8080), API_TOKEN, WEBHOOK_URL, WEBHOOK_SECRET.
  factory Config.fromEnv([Map<String, String>? env]) {
    env ??= Platform.environment;
    var token = env['API_TOKEN'] ?? '';
    final generated = token.isEmpty;
    if (generated) {
      final rnd = Random.secure();
      token = List.generate(32, (_) => rnd.nextInt(256))
          .map((b) => b.toRadixString(16).padLeft(2, '0'))
          .join();
    }
    return Config(
      port: int.tryParse(env['PORT'] ?? '') ?? 8080,
      token: token,
      tokenGenerated: generated,
      webhookUrl: env['WEBHOOK_URL'],
      webhookSecret: env['WEBHOOK_SECRET'],
    );
  }
}
