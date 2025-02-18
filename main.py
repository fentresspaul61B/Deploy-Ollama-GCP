from generate_text import generate, MODEL
from fastapi import FastAPI
import uvicorn


app = FastAPI()


@app.post("/chat")
async def chat(text: str, role: str = "user", model: str = MODEL):
    """Uses ollama model to generate text."""
    return generate(role=role, content=text, model=model)


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
