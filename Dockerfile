FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get update && apt-get install -y curl
# need to install curl in order to use curl command to download Ollama.
RUN curl -fsSL https://ollama.com/install.sh | sh
RUN ollama pull deepseek-r1:7b
COPY main.py .
COPY generate_text.py .
EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]