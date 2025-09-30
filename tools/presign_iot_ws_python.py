# Usage:
# 1) pip install boto3 botocore
# 2) Set AWS creds (env/profile/SSO). Optionally set AWS_PROFILE.
# 3) python3 tools/presign_iot_ws_python.py

import os
from urllib.parse import urlsplit, urlunsplit, urlencode
import boto3
from botocore.awsrequest import AWSRequest
from botocore.auth import SigV4QueryAuth

region = os.getenv("AWS_REGION", "ap-south-1")
endpoint = os.getenv("AWS_IOT_ENDPOINT", "a1t8p573k2ghg7-ats.iot.ap-south-1.amazonaws.com")
profile = os.getenv("AWS_PROFILE", "default")
expires = int(os.getenv("PRESIGN_EXPIRES", "60"))

session = boto3.Session(profile_name=profile)
creds = session.get_credentials().get_frozen_credentials()

url = f"wss://{endpoint}/mqtt"
req = AWSRequest(method="GET", url=url)
SigV4QueryAuth(creds, "iotdevicegateway", region, expires=expires).add_auth(req)

parts = urlsplit(url)
qs = urlencode(req.params)
signed_url = urlunsplit((parts.scheme, parts.netloc, parts.path, qs, parts.fragment))
print("Presigned WebSocket URL:\n" + signed_url + "\n")
print("Paste this into lib/utils/app_urls.dart as AWS_IOT_PRESIGNED_URL.")

