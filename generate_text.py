from ollama import chat
from ollama import ChatResponse


MODEL = "deepseek-r1:7b"


def generate(role: str, content: str, model: str = MODEL) -> str:
    response: ChatResponse = chat(
        model=model,
        messages=[
            {
                'role': role,
                'content': content,
            },
        ]
    )
    return response.message.content


def main():
    print(generate("user", 'Why is the sky blue?'))
    pass


if __name__ == "__main__":
    main()
