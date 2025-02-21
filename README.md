# Deploy-Ollama-GCP

Everything required for ollama to run:

1. Must install ollama using curl
2. Install ollama python package
3. Must download the model to use into memory at deployment time
4. Must start the ollama service as a process. This is the tricky part, as it is not enough to simply download the model, 
and create a fast API endpoint, but we need to start a background process in order to call the model at all. 
5. Once the above steps are completed, then we create the API endpoint, which is another process. 

Tricky parts:

- GitHub actions has a server environment, which is different than the GCP server environment. Meaning that running Ollama
in the GitHub actions script does not do anything when the API is deployed on GCP. 
- We want the model to be pre downloaded into the docker image to reduce cold start times. 


I mean ... I have dealt with all these hurdles already in the past, the new one and the main tricky part is just how to start a background process, while serving the fast API on GCP, and making sure that when server spins up, the background process is also already running. 

One solution, would just to be creating the ollama service as a standalone service, which would only be running the ollama server, and in order to access it, I would just us SSH? Then I could write another simple API, which just hits the existing ollama service but allows for a fast API interface for simplicity. 

