import requests
import subprocess
import json


URL = "https://deepseek-7b-gpu-901342520595.us-central1.run.app/api/chat"
MODEL = "deepseek-r1:7b"

def generate_token():
    """Generates GCP identity token for authentication."""
    command = ["gcloud", "auth", "print-identity-token"]
    token = subprocess.check_output(command).decode("utf-8").strip()
    print("GCP identity token generated. ✔️")
    return token


def chat(content: str, url: str = URL, model: str = MODEL) -> str:
    payload = json.dumps({
        "model": model,
        "messages": [
            {
                "role": "user",
                "content": content
            }
        ],
        "stream": False
    })
    headers = {
        'Content-Type': 'application/json',
        'Authorization': f'Bearer {generate_token()}'
    }
    response = requests.request("POST", url, headers=headers, data=payload)
    return response.text


def main():
    chat("HELLO WORLD!")
    pass


if __name__ == "__main__":
    main()