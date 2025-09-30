// Usage:
// 1) npm i @aws-sdk/credential-providers @aws-sdk/signature-v4 @aws-crypto/sha256-js @aws-sdk/util-format-url
// 2) Set AWS creds (env/profile/SSO). Optionally set AWS_PROFILE.
// 3) node tools/presign_iot_ws_node.mjs

import { fromIni } from "@aws-sdk/credential-providers";
import { fromEnv } from "@aws-sdk/credential-providers";
import { SignatureV4 } from "@aws-sdk/signature-v4";
import { Sha256 } from "@aws-crypto/sha256-js";
import { formatUrl } from "@aws-sdk/util-format-url";

const region = process.env.AWS_REGION || "ap-south-1";
const endpoint = process.env.AWS_IOT_ENDPOINT || "a1t8p573k2ghg7-ats.iot.ap-south-1.amazonaws.com"; // no scheme
const profile = process.env.AWS_PROFILE || "default";
const expiresIn = parseInt(process.env.PRESIGN_EXPIRES || "60", 10);

// Try env creds first, then shared config profile
const credentials = async () => {
  try {
    return await fromEnv()();
  } catch {
    return await fromIni({ profile })();
  }
};

const signer = new SignatureV4({
  service: "iotdevicegateway",
  region,
  credentials,
  sha256: Sha256,
});

const request = {
  method: "GET",
  protocol: "wss:",
  hostname: endpoint,
  path: "/mqtt",
  headers: { host: endpoint },
  query: {},
};

const signed = await signer.presign(request, { expiresIn });
const url = formatUrl(signed);
console.log("Presigned WebSocket URL: \n" + url + "\n");
console.log("Paste this into lib/utils/app_urls.dart as AWS_IOT_PRESIGNED_URL.");

