#!/bin/bash
set -e

# Start the Ollama service in the background
ollama serve &

# Wait a few seconds to ensure Ollama is up and running
sleep 5

# Start the uvicorn server (this replaces the shell process)
exec uvicorn main:app --host 0.0.0.0 --port 8080