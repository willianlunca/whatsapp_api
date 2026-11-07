import os
import sys
import json
import base64
import mimetypes
import urllib.request
import urllib.error
from pathlib import Path

if len(sys.argv) < 4:
    print("Uso: python3 testar_midia.py NUMERO TIPO ARQUIVO")
    print("Tipos: image, audio, video, document")
    sys.exit(1)

numero = sys.argv[1]
tipo = sys.argv[2]
arquivo = Path(sys.argv[3]).expanduser()

if tipo not in ("image", "audio", "video", "document"):
    sys.exit("Tipo inválido")

if not arquivo.is_file():
    sys.exit(f"Arquivo não encontrado: {arquivo}")

conteudo = arquivo.read_bytes()

if len(conteudo) > 15 * 1024 * 1024:
    sys.exit("Arquivo maior que 15 MB")

mime, _ = mimetypes.guess_type(arquivo.name)

mime = mime or "application/octet-stream"

# Compatibilidade de MIME para áudios comuns
if arquivo.suffix.lower() == ".m4a":
    mime = "audio/mp4"
elif arquivo.suffix.lower() == ".mp3":
    mime = "audio/mpeg"
elif arquivo.suffix.lower() == ".ogg":
    mime = "audio/ogg"

dados = {
    "number": numero,
    "type": tipo,
    "fileBase64": base64.b64encode(conteudo).decode(),
    "mimeType": mime,
    "fileName": arquivo.name,
    "caption": f"Teste de envio - {arquivo.name}"
}

token = os.environ.get("API_TOKEN")

if not token:
    sys.exit("API_TOKEN não configurado")

req = urllib.request.Request(
    "http://127.0.0.1:3001/messages/send-media",
    data=json.dumps(dados).encode(),
    headers={
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json"
    },
    method="POST"
)

try:
    with urllib.request.urlopen(req, timeout=120) as resposta:
        print(json.dumps(
            json.loads(resposta.read()),
            indent=2,
            ensure_ascii=False
        ))
except urllib.error.HTTPError as erro:
    print("HTTP:", erro.code)
    print(erro.read().decode())
except urllib.error.URLError as erro:
    print("Erro de conexão:", erro)
