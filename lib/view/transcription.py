from fastapi import FastAPI, Request
import json

app = FastAPI()

@app.post("/webhook")
async def receive_transcription(request: Request):
    payload = await request.json()
    print("Received transcription webhook:")
    print(json.dumps(payload, indent=2))

    # Example structure VideoSDK may send:
    # {
    #   "text": "Hello everyone",
    #   "participantId": "user_123",
    #   "participantName": "Dr. Smith",
    #   "isFinal": True
    # }

    if "text" in payload and "participantId" in payload:
        speaker = payload.get("participantName", payload["participantId"])
        text = payload["text"]
        is_final = payload.get("isFinal", False)

        print(f"[{speaker}] ({'final' if is_final else 'partial'}): {text}")

        # Save to file
        with open("transcriptions.txt", "a", encoding="utf-8") as f:
            f.write(f"[{speaker}] ({'final' if is_final else 'partial'}): {text}\n")

    return {"status": "ok"}
