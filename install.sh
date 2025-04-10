#!/bin/bash

echo "[*] Installing dependencies..."
apt update && apt install -y iptables curl

echo "[*] Applying Growtopia IP redirect rules..."

curl -sO https://raw.githubusercontent.com/davingt/growtopia-proxy/main/hosts.txt

while read line; do
  IP=$(echo $line | awk '{print $1}')
  DOMAIN=$(echo $line | awk '{print $2}')
  
  echo "[*] Redirecting $DOMAIN to $IP"
  iptables -t nat -A OUTPUT -p tcp -d $DOMAIN --dport 17091 -j DNAT --to-destination $IP:17091
done < hosts.txt

echo "[*] Growtopia proxy applied successfully!"
