# FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime
# WORKDIR /app
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt
# RUN apt-get update && apt-get install -y curl
# # need to install curl in order to use curl command to download Ollama.
# RUN curl -fsSL https://ollama.com/install.sh | sh
# RUN ollama pull deepseek-r1:7b
# COPY main.py .
# COPY generate_text.py .
# EXPOSE 8080
# CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]


# Stage 1: Builder stage to download the model
# Stage 1: Builder stage to download the model
FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime as builder

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Install curl and Ollama
RUN apt-get update && apt-get install -y curl
RUN curl -fsSL https://ollama.com/install.sh | sh

# Start Ollama in the background so that pull can connect
RUN ollama serve & \
    sleep 5 && \
    ollama pull deepseek-r1:7b && \
    pkill -f 'ollama serve'

# Stage 2: Final runtime stage
FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the pre-downloaded model files from the builder stage.
# Adjust the source path if Ollama uses a different directory.
COPY --from=builder /root/.ollama/models/ /root/.ollama/models/

# Copy your application code
COPY main.py .
COPY generate_text.py .

EXPOSE 8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]

