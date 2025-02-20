#!/bin/bash
set -e

echo "Starting Ollama service..."
ollama serve &
OLLAMA_PID=$!

# Wait for Ollama to be available on port 11434
echo "Waiting for Ollama to start..."
# Loop until nc (netcat) confirms that port 11434 is listening
while ! nc -z 127.0.0.1 11434; do
  sleep 1
done

echo "Ollama service is up; starting uvicorn..."
exec uvicorn main:app --host 0.0.0.0 --port 8080
