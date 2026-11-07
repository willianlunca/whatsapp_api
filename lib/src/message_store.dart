import 'models.dart';

/// Armazenamento em memória (por enquanto). O próximo passo é trocar por
/// SQLite/Postgres mantendo esta mesma interface de métodos.
class MessageStore {
  static const _maxPerChat = 1000;

  final _data = <String, Map<String, List<WaMessage>>>{};

  void add(WaMessage m) {
    final list = _data
        .putIfAbsent(m.sessionId, () => {})
        .putIfAbsent(m.chatId, () => []);
    list.add(m);
    if (list.length > _maxPerChat) list.removeAt(0);
  }

  List<WaMessage> list(String sessionId, String chatId, {int limit = 50}) {
    final all = _data[sessionId]?[chatId] ?? const <WaMessage>[];
    return all.length <= limit ? List.of(all) : all.sublist(all.length - limit);
  }

  List<Map<String, dynamic>> chats(String sessionId) {
    final chats = _data[sessionId] ?? const <String, List<WaMessage>>{};
    final items = [
      for (final e in chats.entries)
        if (e.value.isNotEmpty) (id: e.key, last: e.value.last),
    ]..sort((a, b) => b.last.timestamp.compareTo(a.last.timestamp));
    return [
      for (final i in items) {'chatId': i.id, 'lastMessage': i.last.toJson()},
    ];
  }

  void clear(String sessionId) => _data.remove(sessionId);
}
