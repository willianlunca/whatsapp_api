# whatsapp_api

Serviço de API em Dart (shelf) para WhatsApp: REST + WebSocket + webhooks, com sessões por QR code. A ideia é ser o equivalente do backend do Whaticket, mas em Dart.

## Status

| Camada | Estado |
|---|---|
| REST, WebSocket, webhooks assinados (HMAC), autenticação por token | pronto (não executado ainda, ver abaixo) |
| Provedor `mock` (QR falso, conecta sozinho, simula mensagens recebidas) | pronto |
| Provedor `native` (protocolo WhatsApp Web multi-device em Dart) | **não existe ainda** |

O código foi escrito sem Dart disponível no ambiente, então ainda não rodou `dart pub get`, `dart analyze` nem os testes. Rode os três primeiro e corrija o que aparecer.

## Rodar

```bash
dart pub get
dart analyze
dart test
API_TOKEN=troque-isto PORT=8080 dart run bin/server.dart
```

Variáveis: `API_TOKEN` (se vazio, gera um token temporário), `PORT`, `WEBHOOK_URL`, `WEBHOOK_SECRET`.

## Endpoints

Todos exigem `Authorization: Bearer <token>` (exceto `/health`).

| Método | Rota | Descrição |
|---|---|---|
| GET | `/health` | status |
| GET/POST | `/v1/sessions` | listar / criar `{ "id": "main", "provider": "mock" }` |
| GET/DELETE | `/v1/sessions/<id>` | detalhe / remover |
| GET | `/v1/sessions/<id>/qr` | QR atual para parear |
| POST | `/v1/sessions/<id>/messages` | enviar `{ "to": "5543999990000", "text": "olá" }` |
| GET | `/v1/sessions/<id>/messages?chatId=...&limit=50` | histórico do chat |
| GET | `/v1/sessions/<id>/chats` | conversas com a última mensagem |
| POST | `/v1/sessions/<id>/simulate` | (só mock) injeta mensagem recebida `{ "from", "text" }` |
| GET/POST/DELETE | `/v1/webhooks` | cadastrar `{ "url", "secret" }` |
| WS | `/v1/ws?sessionId=...` | eventos em tempo real (`qr`, `status`, `message`) |

Para WebSocket sem suporte a headers, use `?token=<token>`.

Webhooks recebem `POST` JSON `{ event, sessionId, data, ts }`, com `X-Signature: sha256=<hmac do corpo>` quando há `secret`.

### Teste rápido

```bash
T=troque-isto
curl -H "Authorization: Bearer $T" -X POST localhost:8080/v1/sessions -d '{"id":"main"}'
curl -H "Authorization: Bearer $T" localhost:8080/v1/sessions/main/qr
curl -H "Authorization: Bearer $T" -X POST localhost:8080/v1/sessions/main/simulate \
     -d '{"from":"5543999990000","text":"oi"}'
```

## Arquitetura

```
bin/server.dart            entrada
lib/src/api/               rotas, auth, erros
lib/src/session_manager    sessões + stream único de eventos
lib/src/message_store      histórico (memória; trocar por SQLite/Postgres)
lib/src/webhooks           entrega assinada
lib/src/providers/         WhatsAppProvider (interface) + MockProvider
```

Tudo fala com a interface `WhatsAppProvider`. Trocar o motor não muda API, webhooks nem a integração com o Nextcloud.

## Próximos passos

1. Rodar analyze/testes e ajustar.
2. Validar o fluxo completo com o provedor `mock` (inclusive o lado Nextcloud Talk).
3. Persistência real (SQLite via `sqlite3` ou Postgres), reconexão e fila de webhooks com retry.
4. Provedor `native`: handshake Noise (XX) sobre WebSocket com o servidor do WhatsApp Web, protobuf, criptografia Signal, multi-device, sincronização de estado. É engenharia reversa de protocolo não documentado: trabalho grande, quebra quando o WhatsApp muda, e contas usadas assim podem ser banidas. Como a interface já está isolada, uma alternativa é um provedor que fale com um motor existente (Baileys, whatsmeow) como sidecar, enquanto o nativo amadurece.

## Integração com Nextcloud Talk

O Talk tem API de bots (webhook assinado + resposta via OCS). Provavelmente dá para ligar esta API ao Talk sem alterar o código do Talk: um bridge mapeia cada chat do WhatsApp para uma sala. Vale confirmar na documentação da sua versão do Talk antes de decidir entre bot e modificação do Talk.
