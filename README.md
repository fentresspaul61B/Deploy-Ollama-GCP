# Deploy-Ollama-GCP

Credit mostly goes to:
https://github.com/richardhe-fundamenta/practical-gcp-examples/blob/main/ollama-cloud-run/README.md

https://www.youtube.com/watch?v=7H6fJVf79o0

https://www.youtube.com/watch?v=NPmNCu1L7uw


I tried many different ways to deploy this, but ulitimately found that it was most simple to use the pre built Ollama API, rather than wrapping the Ollama Python package with a fast API. Then the only thing left to do was to deploy onto GCP. 

The feature that I added which was unique compared to the two solutions above, is that I used GitHub actions for auto deployments, rather than manually configuring the settings in the GCP console. 

## How to call the API with Postman

- Log into GCP console
- Go to GCP cloud terminal and run:
    ```
    gcloud auth print-identity-token
    ```
- Copy the token
- Navigate to cloud run within GCP, and copy the URL of the new API
- Navigate to postman
- Start a new post request
- Past the URL into the post command URL text box, and add:
    ```
    exiting gcp url/api/chat
    ```
- Navigate to the "body" tab
- Select "raw" and then "JSON" and add this to the text box:
    ```bash
    {
        "model": "deepseek-r1:7b",
        "messages": [
        {
            "role": "user",
            "content": "Hello, how are you?"
        }
    ],
    "stream": false
    }
    ```
- Navigate to "Authentication" and select "Bearer", paste in the GCP token from earlier
- Press send and wait!

There will be an initial cold start, but after the first few responses are made, it will get faster. 

## Curl Command
Here is the curl command all together:

```bash
curl --location 'https://deepseek-7b-gpu-901342520595.us-central1.run.app/api/chat' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data '{
  "model": "deepseek-r1:7b",
  "messages": [
    {
      "role": "user",
      "content": "Hello world!"
    }
  ],
  "stream": false
}'
```

## Python Example
With Python:
```python
import requests
import json

url = "https://deepseek-7b-gpu-901342520595.us-central1.run.app/api/chat"

payload = json.dumps({
  "model": "deepseek-r1:7b",
  "messages": [
    {
      "role": "user",
      "content": "Hello world!"
    }
  ],
  "stream": False
})
headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Bearer {ADD_TOKEN_HERE}'
}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.text)
```

## Things I learned along the way 
When we download Ollama, there already is an API built, so we do not need to add the fast API endpoint to create an API endpoint, but rather we can start the Ollama server in the same way we would start a fast API server, as the final step in the Dockerfile. 

For example if you want to use the API locally, you would run something like the curl command bellow, after you already have started running the Ollama server in the background. 

```bash
curl http://localhost:11434/api/chat -d '{
  "model": "deepseek-r1:7b",
  "messages": [
    {
      "role": "user",
      "content": "why is the sky blue?"
    }
  ],
  "stream": false
}'
```

The only thing needed to change to make this a web API (rather than only working locally), is to take the URL from GCP, add the methods to the URL, and add an auth token, and we get:


```bash
curl --location 'https://deepseek-7b-gpu-901342520595.us-central1.run.app/api/chat' \
--header 'Content-Type: application/json' \
--header 'Authorization: ••••••' \
--data '{
  "model": "deepseek-r1:7b",
  "messages": [
    {
      "role": "user",
      "content": "why is the sky blue?"
    }
  ],
  "stream": false
}'
```

# TODO:
Test the API response time for longer prompts. 

Experiment with smaller models, to see if response times are faster. 





