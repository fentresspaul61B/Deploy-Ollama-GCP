# ---------------- LAST NON ERROR VERSION BUT NOT WORKING ---------------------
# FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime as builder

# WORKDIR /app

# # Install Python dependencies
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# # Install curl and Ollama
# RUN apt-get update && apt-get install -y curl
# RUN curl -fsSL https://ollama.com/install.sh | sh

# # Start Ollama in the background so that pull can connect, wait a bit, then pull the model
# RUN ollama serve & \
#     sleep 5 && \
#     ollama pull deepseek-r1:7b && \
#     pkill -f 'ollama serve'

# # Stage 2: Final runtime stage
# FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

# WORKDIR /app

# # Install Python dependencies
# COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# # Copy the pre-downloaded model files from the builder stage.
# COPY --from=builder /root/.ollama/models/ /root/.ollama/models/

# # Copy your application code
# COPY main.py .
# COPY generate_text.py .

# # Copy the entrypoint script and set permissions
# COPY entrypoint.sh /entrypoint.sh
# RUN chmod +x /entrypoint.sh

# EXPOSE 8080

# # Use the entrypoint script to start Ollama and uvicorn
# ENTRYPOINT ["/entrypoint.sh"]
# ---------------- LAST NON ERROR VERSION BUT NOT WORKING ---------------------



# FROM pytorch/pytorch:2.0.0-cuda11.7-cudnn8-runtime

# WORKDIR /app

# # Install curl and Ollama
# RUN apt-get update && apt-get install -y curl
# RUN curl -fsSL https://ollama.com/install.sh | sh

# # Expose the port that Ollama uses (default is 11434)
# EXPOSE 11434

# # Run the Ollama service
# CMD ["ollama", "serve"]


FROM ollama/ollama

# Listen on all interfaces, port 8080
ENV OLLAMA_HOST 0.0.0.0:8080

# Store model weight files in /models
ENV OLLAMA_MODELS /models

# Reduce logging verbosity
ENV OLLAMA_DEBUG false

# Never unload model weights from the GPU
ENV OLLAMA_KEEP_ALIVE -1 

# Store the model weights in the container image
ENV MODEL deepseek-r1:7b
RUN ollama serve & sleep 5 && ollama pull $MODEL 

# Start Ollama
ENTRYPOINT ["ollama", "serve"]



