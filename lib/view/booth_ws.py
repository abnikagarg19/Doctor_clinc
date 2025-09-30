#!/usr/bin/env python3
# app.py
# A FastAPI WebSocket bridge for AWS IoT Core MQTT → browser clients.
# - Subscribes to AWS IoT topic(s)
# - Broadcasts messages to any WS client connected to /ws/iot

import os
import json
import uuid
import asyncio
from datetime import datetime, timezone
from typing import Set

import boto3
from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.responses import JSONResponse
from awscrt import auth, mqtt
from awsiot import mqtt_connection_builder as mcb

# ------------------------------------------------------------------------------
# Configuration (override via ENV)
# ------------------------------------------------------------------------------
IDENTITY_POOL_ID = os.getenv("IDENTITY_POOL_ID", "ap-south-1:7d92ef95-41ab-4162-a488-b10147999b89")
REGION           = os.getenv("REGION",           "ap-south-1")
IOT_ENDPOINT     = os.getenv("IOT_ENDPOINT",     "a1t8p573k2ghg7-ats.iot.ap-south-1.amazonaws.com")
TOPIC_FILTER     = os.getenv("TOPIC_FILTER",     "ecg_data/temperature")    # supports wildcards
CLIENT_ID        = os.getenv("CLIENT_ID",        f"ws-bridge-{uuid.uuid4()}")
KEEP_ALIVE_SECS  = int(os.getenv("KEEP_ALIVE_SECS", "60"))
QOS_LEVEL        = mqtt.QoS.AT_LEAST_ONCE        # reliable delivery to subscriber

# ------------------------------------------------------------------------------
# IoT → WS Bridge
# ------------------------------------------------------------------------------
class IotWebSocketBridge:
    def __init__(self):
        self.clients: Set[WebSocket] = set()
        self.queue: asyncio.Queue = asyncio.Queue()
        self.mqtt_conn = None
        self.loop = asyncio.get_event_loop()
        self._broadcaster_task: asyncio.Task | None = None

    # -------- MQTT Callbacks --------
    def on_message(self, topic: str, payload: bytes, **kwargs):
        """Called by AWS CRT thread when an MQTT message arrives; push to asyncio queue."""
        try:
            text = payload.decode("utf-8", errors="replace")
        except Exception:
            text = "<binary>"

        # 🖨️ Debug log
        print(f"📥 MQTT message on [{topic}]: {text}")

        msg = {
            "topic": topic,
            "payload": self._maybe_parse_json(text),
            "received_at": datetime.now(timezone.utc).isoformat()
        }
        # Hand off to asyncio thread
        self.loop.call_soon_threadsafe(self.queue.put_nowait, msg)


    def on_connection_interrupted(self, connection, error, **kwargs):
        print(f"⚠️ MQTT connection interrupted: {error}")

    def on_connection_resumed(self, connection, return_code, session_present, **kwargs):
        print(f"🔄 MQTT connection resumed: rc={return_code}, session_present={session_present}")

    # -------- Lifecycle --------
    async def start(self):
        """Connect to AWS IoT and subscribe; start broadcaster."""
        # Get temporary creds from Cognito
        cog = boto3.client("cognito-identity", region_name=REGION)
        identity_id = cog.get_id(IdentityPoolId=IDENTITY_POOL_ID)["IdentityId"]
        creds = cog.get_credentials_for_identity(IdentityId=identity_id)["Credentials"]

        provider = auth.AwsCredentialsProvider.new_static(
            creds["AccessKeyId"], creds["SecretKey"], creds["SessionToken"]
        )

        # Build MQTT connection over SigV4 WebSockets
        self.mqtt_conn = mcb.websockets_with_default_aws_signing(
            endpoint=IOT_ENDPOINT,
            region=REGION,
            credentials_provider=provider,
            client_id=CLIENT_ID,
            clean_session=False,
            keep_alive_secs=KEEP_ALIVE_SECS,
            on_connection_interrupted=self.on_connection_interrupted,
            on_connection_resumed=self.on_connection_resumed,
        )

        print(f"🔌 Connecting to AWS IoT: {IOT_ENDPOINT} as {CLIENT_ID} …")
        await asyncio.get_event_loop().run_in_executor(None, self.mqtt_conn.connect().result)
        print("✅ MQTT connected")

        # ---- Subscribe to multiple topics ----
        topics = [
            ("ecg_data/stethoscope", mqtt.QoS.AT_MOST_ONCE),
            ("ecg_data/SPO2", mqtt.QoS.AT_LEAST_ONCE),
            ("ecg_data/temperature", mqtt.QoS.AT_LEAST_ONCE),
            ("ecg_data/ecg", mqtt.QoS.AT_LEAST_ONCE),
        ]

        print(f"🔔 Subscribing to topics: {[t[0] for t in topics]}")
        for topic, qos in topics:
            sub_future, _ = self.mqtt_conn.subscribe(
                topic=topic,
                qos=qos,
                callback=self.on_message
            )
            await asyncio.get_event_loop().run_in_executor(None, sub_future.result)
            print(f"✅ Subscribed to {topic} with QoS={qos.name}")

        # Start broadcasting loop
        self._broadcaster_task = asyncio.create_task(self._broadcaster())

    async def stop(self):
        """Disconnect from AWS IoT and stop broadcaster."""
        if self._broadcaster_task:
            self._broadcaster_task.cancel()
            try:
                await self._broadcaster_task
            except asyncio.CancelledError:
                pass
        if self.mqtt_conn:
            await asyncio.get_event_loop().run_in_executor(None, self.mqtt_conn.disconnect().result)
            print("🔻 MQTT disconnected")

    async def _broadcaster(self):
        """Reads from queue and sends to all connected WS clients."""
        while True:
            msg = await self.queue.get()
            if not self.clients:
                continue
            data = json.dumps(msg, ensure_ascii=False)
            dead = []
            for ws in list(self.clients):
                try:
                    await ws.send_text(data)
                except Exception:
                    dead.append(ws)
            for ws in dead:
                await self._safe_discard(ws)

    # -------- WS client management --------
    async def register(self, websocket: WebSocket):
        await websocket.accept()
        self.clients.add(websocket)
        await websocket.send_text(json.dumps({"type": "welcome", "client_count": len(self.clients)}))

    async def unregister(self, websocket: WebSocket):
        await self._safe_discard(websocket)

    async def _safe_discard(self, websocket: WebSocket):
        try:
            if websocket in self.clients:
                self.clients.discard(websocket)
                await websocket.close()
        except Exception:
            pass

    # -------- Helpers --------
    @staticmethod
    def _maybe_parse_json(text: str):
        try:
            return json.loads(text)
        except Exception:
            return text


bridge = IotWebSocketBridge()
app = FastAPI(title="AWS IoT → WebSocket Bridge")

# ------------------------------------------------------------------------------
# FastAPI lifecycle
# ------------------------------------------------------------------------------
@app.on_event("startup")
async def _startup():
    # Basic checks to avoid silent misconfig
    if "YOUR-COGNITO-IDENTITY-POOL-ID" in IDENTITY_POOL_ID or "YOUR-ATS-ENDPOINT" in IOT_ENDPOINT:
        print("⚠️  Set IDENTITY_POOL_ID and IOT_ENDPOINT env vars before running.")
    await bridge.start()

@app.on_event("shutdown")
async def _shutdown():
    await bridge.stop()

# ------------------------------------------------------------------------------
# WebSocket endpoint
# ------------------------------------------------------------------------------
@app.websocket("/ws/iot")
async def ws_iot(websocket: WebSocket):
    await bridge.register(websocket)
    try:
        # Keep the socket open; optionally react to pings from client
        while True:
            # We don't require incoming messages; just wait to detect disconnects
            await websocket.receive_text()
    except WebSocketDisconnect:
        pass
    finally:
        await bridge.unregister(websocket)

# ------------------------------------------------------------------------------
# (Optional) Health check
# ------------------------------------------------------------------------------
@app.get("/healthz")
def healthz():
    return JSONResponse({"status": "ok", "clients": len(bridge.clients)})
