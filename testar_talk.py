import base64
import getpass
import json
import urllib.request
import urllib.error

base = input("URL do Nextcloud: ").strip().rstrip("/")
user = input("Usuário Nextcloud: ").strip()
password = getpass.getpass("Senha de aplicativo: ")
room = input("Token da sala Talk: ").strip()

url = f"{base}/ocs/v2.php/apps/spreed/api/v1/chat/{room}?limit=10"

auth = base64.b64encode(
    f"{user}:{password}".encode()
).decode()

req = urllib.request.Request(
    url,
    headers={
        "Authorization": f"Basic {auth}",
        "OCS-APIRequest": "true",
        "Accept": "application/json",
    },
)

try:
    with urllib.request.urlopen(req, timeout=15) as response:
        data = json.load(response)

    messages = data.get("ocs", {}).get("data", [])

    print("\nMensagens encontradas:", len(messages))

    for msg in messages:
        print(json.dumps({
            "id": msg.get("id"),
            "actorId": msg.get("actorId"),
            "actorType": msg.get("actorType"),
            "messageType": msg.get("messageType"),
            "isReplyable": msg.get("isReplyable"),
        }, ensure_ascii=False, indent=2))

except urllib.error.HTTPError as e:
    print("Erro HTTP:", e.code)
    print(e.read().decode()[:1000])
except Exception as e:
    print("Erro:", e)
