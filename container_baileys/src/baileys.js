
import express from 'express'
import makeWASocket, {
  DisconnectReason,
  useMultiFileAuthState,
  Browsers,
  downloadMediaMessage
} from '@whiskeysockets/baileys'
import pino from 'pino'
import QRCode from 'qrcode'
import qrcodeTerminal from 'qrcode-terminal'

const app = express()
app.use(express.json({ limit: '22mb' }))

const PORT = Number(process.env.PORT || 3001)
const AUTH_DIR = process.env.AUTH_DIR || '/app/data/auth'
const API_TOKEN = process.env.API_TOKEN
const SERVERPOD_WEBHOOK_URL = process.env.SERVERPOD_WEBHOOK_URL
const SERVERPOD_WEBHOOK_TOKEN = process.env.SERVERPOD_WEBHOOK_TOKEN

if (!API_TOKEN) {
  throw new Error('API_TOKEN não configurado')
}

const logger = pino({ level: 'warn' })

let sock = null
let qrCode = null
let status = 'starting'
let generation = 0
let reconnectTimer = null
let reconnectAttempts = 0

const mediaCache = new Map()

const MEDIA_TTL_MS = 15 * 60 * 1000
const MAX_MEDIA_BYTES = 50 * 1024 * 1024
const MAX_CACHE_BYTES = 100 * 1024 * 1024

function cleanMediaCache() {
  const now = Date.now()

  for (const [id, item] of mediaCache) {
    if (now >= item.expiresAt) {
      mediaCache.delete(id)
    }
  }
}

setInterval(cleanMediaCache, 60 * 1000).unref()

function storeMedia(id, buffer, metadata) {
  cleanMediaCache()

  if (!Buffer.isBuffer(buffer) ||
      buffer.length === 0 ||
      buffer.length > MAX_MEDIA_BYTES) {
    throw new Error('Mídia vazia ou maior que 50 MB')
  }

  let totalBytes = 0

  for (const item of mediaCache.values()) {
    totalBytes += item.buffer.length
  }

  if (totalBytes + buffer.length > MAX_CACHE_BYTES) {
    throw new Error('Cache de mídias cheio')
  }

  mediaCache.set(id, {
    buffer,
    ...metadata,
    expiresAt: Date.now() + MEDIA_TTL_MS
  })
}

function authenticate(req, res, next) {
  if (req.headers.authorization !== `Bearer ${API_TOKEN}`) {
    return res.status(401).json({
      error: 'Unauthorized'
    })
  }
  next()
}

app.use(authenticate)

// Estado da conexão
app.get('/status', (req, res) => {
  res.json({
    status,
    connected: status === 'connected',
    qrAvailable: Boolean(qrCode),
    account: status === 'connected'
      ? sock?.user?.id || null
      : null
  })
})

// QR Code em JSON para futura integração Dart
app.get('/qr', async (req, res) => {
  if (!qrCode) {
    return res.status(404).json({
      status,
      error: 'QR Code indisponível'
    })
  }

  try {
    const image = await QRCode.toDataURL(qrCode)
    res.set('Cache-Control', 'no-store')
    res.json({ image })
  } catch {
    res.status(500).json({ error: 'Erro ao gerar QR Code' })
  }
})

// QR Code como PNG
app.get('/qr/image', async (req, res) => {
  if (!qrCode) {
    return res.status(404).json({
      status,
      error: 'QR Code indisponível'
    })
  }

  try {
    const image = await QRCode.toBuffer(qrCode)
    res.set('Content-Type', 'image/png')
    res.set('Cache-Control', 'no-store')
    res.send(image)
  } catch {
    res.status(500).json({ error: 'Erro ao gerar imagem' })
  }
})

// Enviar mensagem de texto
app.post('/messages/send', async (req, res) => {
  if (status !== 'connected' || !sock) {
    return res.status(503).json({
      error: 'WhatsApp desconectado'
    })
  }

  const { number, jid: recipientJid, message } = req.body || {}

  const validNumber =
    typeof number === 'string' &&
    /^\d{10,15}$/.test(number)

  const validJid =
    typeof recipientJid === 'string' &&
    /^\d{1,20}@(lid|s\.whatsapp\.net)$/.test(recipientJid)

  if (
    (validNumber === validJid) ||
    typeof message !== 'string' ||
    !message.trim() ||
    message.length > 4096
  ) {
    return res.status(400).json({
      error: 'Destinatário ou mensagem inválidos'
    })
  }

  try {
    const jid = validJid
      ? recipientJid
      : `${number}@s.whatsapp.net`

    const sent = await sock.sendMessage(jid, {
      text: message
    })

    res.json({
      success: true,
      messageId: sent?.key?.id || null,
      to: jid
    })
  } catch (error) {
    logger.error(error, 'Falha no envio')

    res.status(500).json({
      error: 'Falha no envio'
    })
  }
})

// Enviar imagem pelo WhatsApp
app.post('/messages/send-image', async (req, res) => {
  if (status !== 'connected' || !sock) {
    return res.status(503).json({
      error: 'WhatsApp desconectado'
    })
  }

  const { number, imageBase64, caption = '' } = req.body || {}

  if (
    typeof number !== 'string' ||
    !/^\d{10,15}$/.test(number) ||
    typeof imageBase64 !== 'string' ||
    !imageBase64 ||
    typeof caption !== 'string' ||
    caption.length > 4096
  ) {
    return res.status(400).json({
      error: 'Dados inválidos'
    })
  }

  try {
    const results = await sock.onWhatsApp(
      `${number}@s.whatsapp.net`
    )

    const jid = results?.find(item => item.exists)?.jid

    if (!jid) {
      return res.status(404).json({
        error: 'Número não encontrado no WhatsApp'
      })
    }

    const image = Buffer.from(imageBase64, 'base64')

    if (!image.length || image.length > 5 * 1024 * 1024) {
      return res.status(400).json({
        error: 'Imagem vazia ou maior que 5 MB'
      })
    }

    const sent = await sock.sendMessage(jid, {
      image,
      caption
    })

    return res.json({
      success: true,
      messageId: sent?.key?.id || null,
      to: jid
    })
  } catch (error) {
    logger.error(error, 'Falha no envio de imagem')

    return res.status(500).json({
      error: 'Falha no envio de imagem'
    })
  }
})

// Enviar imagens, áudios, vídeos e documentos
app.post('/messages/send-media', async (req, res) => {
  if (status !== 'connected' || !sock) {
    return res.status(503).json({
      error: 'WhatsApp desconectado'
    })
  }

  const {
    number,
    type,
    fileBase64,
    mimeType,
    fileName,
    caption = ''
  } = req.body || {}

  const allowedTypes = ['image', 'audio', 'video', 'document']

  if (
    typeof number !== 'string' ||
    !/^\d{10,15}$/.test(number) ||
    !allowedTypes.includes(type) ||
    typeof fileBase64 !== 'string' ||
    !fileBase64 ||
    typeof mimeType !== 'string' ||
    !/^[\w.+-]+\/[\w.+-]+$/.test(mimeType) ||
    typeof caption !== 'string' ||
    caption.length > 4096 ||
    (fileName !== undefined &&
      (typeof fileName !== 'string' ||
       !fileName ||
       fileName.length > 255))
  ) {
    return res.status(400).json({
      error: 'Dados de mídia inválidos'
    })
  }

  const mimeMatchesType = {
    image: mimeType === 'image/png' || mimeType === 'image/jpeg',
    audio: ['audio/mpeg', 'audio/mp4', 'audio/ogg'].includes(mimeType),
    video: mimeType === 'video/mp4',
    document: true
  }

  if (!mimeMatchesType[type]) {
    return res.status(400).json({
      error: 'MIME incompatível com o tipo de mídia'
    })
  }

  if (
    !/^[A-Za-z0-9+/]+={0,2}$/.test(fileBase64) ||
    fileBase64.length % 4 !== 0
  ) {
    return res.status(400).json({
      error: 'Base64 inválido'
    })
  }

  const file = Buffer.from(fileBase64, 'base64')

  if (!file.length || file.length > 15 * 1024 * 1024) {
    return res.status(413).json({
      error: 'Arquivo vazio ou maior que 15 MB'
    })
  }

  try {
    const results = await sock.onWhatsApp(
      `${number}@s.whatsapp.net`
    )

    const jid = results?.find(item => item.exists)?.jid

    if (!jid) {
      return res.status(404).json({
        error: 'Número não encontrado no WhatsApp'
      })
    }

    let payload

    switch (type) {
      case 'image':
        payload = {
          image: file,
          mimetype: mimeType,
          caption
        }
        break

      case 'audio':
        payload = {
          audio: file,
          mimetype: mimeType,
          ptt: false
        }
        break

      case 'video':
        payload = {
          video: file,
          mimetype: mimeType,
          caption
        }
        break

      case 'document':
        payload = {
          document: file,
          mimetype: mimeType,
          fileName: fileName || 'arquivo',
          caption
        }
        break
    }

    const sent = await sock.sendMessage(jid, payload)

    return res.json({
      success: true,
      messageId: sent?.key?.id || null,
      to: jid,
      type,
      fileName: fileName || null
    })
  } catch (error) {
    logger.error(error, 'Falha no envio de mídia')

    return res.status(500).json({
      error: 'Falha no envio de mídia'
    })
  }
})

// Encaminhar eventos ao Serverpod
async function sendWebhook(event) {
  if (
    event.event === 'connection.open' ||
    event.event === 'connection.close'
  ) {
    console.log('[WEBHOOK] Evento de conexão local:', event.event)
    return
  }

  if (!SERVERPOD_WEBHOOK_URL || !SERVERPOD_WEBHOOK_TOKEN) {
    console.log('Evento local:', JSON.stringify(event))
    return
  }

  try {
    console.log('[WEBHOOK] Enviando evento:', {
      event: event.event,
      messageId: event.messageId || null,
      mediaType: event.mediaType || null
    })

    const response = await fetch(SERVERPOD_WEBHOOK_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${SERVERPOD_WEBHOOK_TOKEN}`
      },
      body: JSON.stringify(event),
      signal: AbortSignal.timeout(10000)
    })

    if (!response.ok) {
      const responseBody = await response.text()

      throw new Error(
        `Webhook HTTP ${response.status} - ${responseBody}`
      )
    }
  } catch (error) {
    logger.error(error, 'Falha ao entregar webhook')
  }
}

// Consultar destinatário no WhatsApp
app.get('/contacts/resolve/:number', async (req, res) => {
  if (status !== 'connected' || !sock) {
    return res.status(503).json({
      error: 'WhatsApp desconectado'
    })
  }

  const { number } = req.params

  if (!/^\d{10,15}$/.test(number)) {
    return res.status(400).json({
      error: 'Número inválido'
    })
  }

  try {
    const results = await sock.onWhatsApp(
      `${number}@s.whatsapp.net`
    )

    return res.json({
      number,
      results: results || []
    })
  } catch (error) {
    logger.error(error, 'Erro ao consultar número')

    return res.status(500).json({
      error: 'Falha ao consultar destinatário'
    })
  }
})

app.get('/media/:messageId', (req, res) => {
  cleanMediaCache()

  const { messageId } = req.params
  const item = mediaCache.get(messageId)

  if (!item) {
    return res.status(404).json({
      error: 'Mídia não encontrada ou expirada'
    })
  }

  res.setHeader('Content-Type', item.mimeType)
  res.setHeader('Content-Length', item.buffer.length)
  res.setHeader('Cache-Control', 'no-store')
  res.setHeader('X-Media-Type', item.mediaType)
  res.setHeader(
    'X-Media-File-Name',
    encodeURIComponent(item.fileName)
  )

  return res.send(item.buffer)
})

// Inicializar WhatsApp
async function connectWhatsApp() {
  const currentGeneration = ++generation

  clearTimeout(reconnectTimer)
  status = 'connecting'
  qrCode = null

  try {
    const { state, saveCreds } =
      await useMultiFileAuthState(AUTH_DIR)

    const connection = makeWASocket({
      auth: state,
      logger,
      browser: Browsers.ubuntu('WhatsApp Talk Bridge'),
      markOnlineOnConnect: false,
      syncFullHistory: false
    })

    sock = connection

    connection.ev.on('creds.update', saveCreds)

    connection.ev.on('connection.update', async update => {
      if (currentGeneration !== generation) return

      const { connection: state, qr, lastDisconnect } = update

      if (qr) {
        qrCode = qr
        status = 'waiting_qr'

        console.log('\n=== QR CODE WHATSAPP ===\n')
        qrcodeTerminal.generate(qr, { small: true })
      }

      if (state === 'open') {
        status = 'connected'
        qrCode = null
        reconnectAttempts = 0

        console.log('WhatsApp conectado!')
        console.log('Conta:', connection.user?.id)

        void sendWebhook({
          event: 'connection.open',
          account: connection.user?.id
        })
      }

      if (state === 'close') {
        sock = null
        qrCode = null

        const code =
          lastDisconnect?.error?.output?.statusCode

        console.log('WhatsApp desconectado. Código:', code)

        void sendWebhook({
          event: 'connection.close',
          code
        })

        if (code === DisconnectReason.loggedOut) {
          status = 'logged_out'
          console.log('Sessão encerrada. Reinicie para parear novamente.')
          return
        }

        status = 'reconnecting'
        reconnectAttempts++

        const delay = Math.min(
          5000 * reconnectAttempts,
          30000
        )

        reconnectTimer = setTimeout(() => {
          connectWhatsApp().catch(console.error)
        }, delay)
      }
    })

    connection.ev.on('messages.upsert', ({ messages, type }) => {
      if (currentGeneration !== generation) return

      console.log(
        '[BAILEYS] Evento messages.upsert:',
        JSON.stringify({
          type,
          quantidade: messages.length
        })
      )

      for (const msg of messages) {
        const from = msg.key.remoteJid || ''
        const fromMe = msg.key.fromMe || false

        console.log(
          '[BAILEYS] Mensagem recebida:',
          JSON.stringify({
            from,
            fromMe,
            messageId: msg.key.id,
            messageType: Object.keys(msg.message || {}),
            eventType: type
          })
        )

        if (fromMe || !msg.message) continue

        // Aceita identificadores tradicionais e LID.
        if (
          !from.endsWith('@s.whatsapp.net') &&
          !from.endsWith('@lid')
        ) continue

        const content =
          msg.message.ephemeralMessage?.message ||
          msg.message.viewOnceMessage?.message ||
          msg.message

        const text =
          content.conversation ||
          content.extendedTextMessage?.text ||
          content.imageMessage?.caption ||
          content.videoMessage?.caption ||
          content.documentMessage?.caption ||
          ''

        let mediaType = null
        let mimeType = null
        let fileName = null
        let fileSize = null

        if (content.imageMessage) {
          mediaType = 'image'
          mimeType = content.imageMessage.mimetype || 'image/jpeg'
          fileSize = content.imageMessage.fileLength?.toString() || null
        } else if (content.videoMessage) {
          mediaType = 'video'
          mimeType = content.videoMessage.mimetype || 'video/mp4'
          fileSize = content.videoMessage.fileLength?.toString() || null
        } else if (content.audioMessage) {
          mediaType = 'audio'
          mimeType = content.audioMessage.mimetype || 'audio/ogg'
          fileSize = content.audioMessage.fileLength?.toString() || null
        } else if (content.documentMessage) {
          mediaType = 'document'
          mimeType = content.documentMessage.mimetype || 'application/octet-stream'
          fileName = content.documentMessage.fileName || null
          fileSize = content.documentMessage.fileLength?.toString() || null
        } else if (content.stickerMessage) {
          mediaType = 'sticker'
          mimeType = content.stickerMessage.mimetype || 'image/webp'
          fileSize = content.stickerMessage.fileLength?.toString() || null
        }

        if (!text && !mediaType) continue

        console.log(
          '[BAILEYS] Mensagem identificada:',
          JSON.stringify({
            from,
            text,
            mediaType,
            mimeType,
            fileName,
            fileSize
          })
        )

        if (mediaType) {
          void (async () => {
            try {
              const buffer = await downloadMediaMessage(
                msg,
                'buffer',
                {},
                {
                  logger,
                  reuploadRequest: connection.updateMediaMessage
                }
              )

              const extensions = {
                image: 'jpg',
                video: 'mp4',
                audio: 'ogg',
                document: 'bin',
                sticker: 'webp'
              }

              const safeName = fileName ||
                `${msg.key.id}.${extensions[mediaType] || 'bin'}`

              storeMedia(msg.key.id, buffer, {
                from,
                mediaType,
                mimeType,
                fileName: safeName,
                caption: text
              })

              await sendWebhook({
                event: 'media.ready',
                messageId: msg.key.id,
                from,
                text: text || `[${mediaType}]`,
                mediaType,
                mimeType,
                fileName: safeName,
                fileSize: buffer.length,
                timestamp: String(msg.messageTimestamp || '')
              })

              console.log(
                '[BAILEYS] Mídia baixada:',
                JSON.stringify({
                  messageId: msg.key.id,
                  mediaType,
                  bytes: buffer.length,
                  fileName: safeName
                })
              )
            } catch (error) {
              logger.error({
                messageId: msg.key.id,
                error: error.message
              }, 'Falha ao baixar mídia recebida')
            }
          })()

          continue
        }

        void sendWebhook({
          event: 'message.received',
          messageId: msg.key.id,
          from,
          text,
          timestamp: String(msg.messageTimestamp || '')
        })
      }
    })
  } catch (error) {
    logger.error(error, 'Erro ao iniciar Baileys')
    status = 'error'

    reconnectTimer = setTimeout(() => {
      connectWhatsApp().catch(console.error)
    }, 10000)
  }
}

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Baileys iniciado na porta ${PORT}`)
  connectWhatsApp().catch(console.error)
})
