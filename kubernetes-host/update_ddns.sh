#!/bin/bash

# Cloudflare API 설정
ZONE_ID="..."             # Cloudflare에서 확인한 Zone ID
RECORD_ID="..."         # 업데이트할 A 레코드의 Record ID
CF_API_TOKEN="..."      # 생성한 API 토큰
CF_RECORD="..."
TTL=120  # DNS TTL (초)

# 현재 공인 IP 확인 (api.ipify.org 사용)
CURRENT_IP=$(curl -s https://api.ipify.org)

# Cloudflare에 등록된 현재 IP 조회
DNS_IP=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
  -H "Authorization: Bearer ${CF_API_TOKEN}" \
  -H "Content-Type: application/json" | jq -r '.result.content')

if [ "$CURRENT_IP" != "$DNS_IP" ]; then
    echo "[CLOUDFLARE_UPDATE_DDNS] IP change detected: $DNS_IP -> $CURRENT_IP"
    # Cloudflare에 A 레코드 업데이트 요청
    # (proxied: false는 필요에 따라 true로 변경 가능)
    RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/dns_records/${RECORD_ID}" \
      -H "Authorization: Bearer ${CF_API_TOKEN}" \
      -H "Content-Type: application/json" \
      --data "{\"type\":\"A\",\"name\":\"${CF_RECORD}\",\"content\":\"${CURRENT_IP}\",\"ttl\":${TTL},\"proxied\":false}")
    echo "[CLOUDFLARE_UPDATE_DDNS] Upadte Respone : $RESPONSE"
else
    echo "[CLOUDFLARE_UPDATE_DDNS] Nothing updated, Current IP: $CURRENT_IP"
fi
