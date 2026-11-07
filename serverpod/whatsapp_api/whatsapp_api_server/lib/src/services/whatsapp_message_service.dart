import 'package:serverpod/serverpod.dart';

import '../generated/whatsapp_contact.dart';
import '../generated/whatsapp_conversation.dart';
import '../generated/whatsapp_message.dart';

import 'nextcloud_talk_service.dart';
import 'whatsapp_media_service.dart';

class WhatsappMessageService {
  static Future<bool> process(
    Session session,
    Map<String, dynamic> data,
  ) async {
    final event = data['event'];

    if (event != 'message.received' && event != 'media.ready') {
      throw const FormatException('Evento não suportado');
    }

    final isMedia = event == 'media.ready';

    final messageId = data['messageId'];
    final jid = data['from'];
    final rawTimestamp = data['timestamp'];

    final rawContent = data['text'];

    final mediaType = data['mediaType'];
    final mimeType = data['mimeType'];
    final fileName = data['fileName'];

    if (messageId is! String ||
        messageId.trim().isEmpty ||
        jid is! String ||
        jid.trim().isEmpty) {
      throw const FormatException('Dados da mensagem inválidos');
    }

    if (isMedia) {
      if (mediaType is! String ||
          mediaType.trim().isEmpty ||
          mimeType is! String ||
          mimeType.trim().isEmpty ||
          fileName is! String ||
          fileName.trim().isEmpty) {
        throw const FormatException('Dados da mídia inválidos');
      }
    } else {
      if (rawContent is! String || rawContent.trim().isEmpty) {
        throw const FormatException('Conteúdo da mensagem inválido');
      }
    }

    final seconds = rawTimestamp is int
        ? rawTimestamp
        : int.tryParse(rawTimestamp?.toString() ?? '');

    if (seconds == null || seconds <= 0) {
      throw const FormatException('Timestamp inválido');
    }

    final messageTime = DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000,
      isUtc: true,
    );

    final content = isMedia
        ? ((rawContent is String && rawContent.trim().isNotEmpty)
              ? rawContent
              : '[$mediaType]')
        : rawContent as String;

    // Para mídias, concluímos a transferência antes de gravar
    // a mensagem. Assim, uma falha não marca o arquivo como
    // processado no PostgreSQL.
    String? remotePath;

    if (isMedia) {
      remotePath = await WhatsappMediaService.transferToTalk(
        messageId: messageId,
        mediaType: mediaType as String,
        mimeType: mimeType as String,
        fileName: fileName as String,
      );

      session.log(
        'Mídia transferida para o Nextcloud Talk: $remotePath',
        level: LogLevel.info,
      );
    }

    final inserted = await session.db.transaction((transaction) async {
      final existingMessage = await WhatsappMessage.db.findFirstRow(
        session,
        where: (t) => t.whatsappMessageId.equals(messageId),
        transaction: transaction,
      );

      if (existingMessage != null) {
        return false;
      }

      final now = DateTime.now().toUtc();

      var contact = await WhatsappContact.db.findFirstRow(
        session,
        where: (t) => t.jid.equals(jid),
        transaction: transaction,
      );

      contact ??= await WhatsappContact.db.insertRow(
        session,
        WhatsappContact(jid: jid, createdAt: now, updatedAt: now),
        transaction: transaction,
      );

      var conversation = await WhatsappConversation.db.findFirstRow(
        session,
        where: (t) => t.contactId.equals(contact!.id!),
        transaction: transaction,
      );

      conversation ??= await WhatsappConversation.db.insertRow(
        session,
        WhatsappConversation(
          contactId: contact.id!,
          status: 'open',
          lastMessageAt: messageTime,
          createdAt: now,
          updatedAt: now,
        ),
        transaction: transaction,
      );

      await WhatsappMessage.db.insertRow(
        session,
        WhatsappMessage(
          conversationId: conversation.id!,
          whatsappMessageId: messageId,
          senderJid: jid,
          fromMe: false,
          content: isMedia ? '$content\nArquivo: $remotePath' : content,
          timestamp: messageTime,
          createdAt: now,
        ),
        transaction: transaction,
      );

      if (conversation.lastMessageAt == null ||
          messageTime.isAfter(conversation.lastMessageAt!)) {
        await WhatsappConversation.db.updateRow(
          session,
          conversation.copyWith(lastMessageAt: messageTime, updatedAt: now),
          transaction: transaction,
        );
      }

      return true;
    });

    // O compartilhamento OCS já publica o anexo no Talk.
    // Não enviamos uma segunda mensagem para a mesma mídia.
    if (isMedia) {
      return inserted;
    }

    // Mantém o comportamento original das mensagens de texto.
    if (inserted) {
      try {
        await NextcloudTalkService.sendMessage(
          message:
              '📱 WhatsApp\n'
              'Contato: $jid\n\n'
              '$content',
        );
      } catch (error, stackTrace) {
        session.log(
          'Mensagem gravada no PostgreSQL, mas falhou o envio '
          'ao Nextcloud Talk: $error\n$stackTrace',
          level: LogLevel.error,
        );
      }
    }

    return inserted;
  }
}
