#!/bin/sh

OLD_IP=`cat current_ip.txt`
IP_ADDRESS=$(curl -s "https://icanhazip.com")
JSON_DATA=$(jq -n \
    --arg ip "$IP_ADDRESS" \
    '{"data":$ip}')

if [ "$IP_ADDRESS" != "$OLD_IP" ]; then 
    curl -s -X PUT \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $DO_API_KEY" \
        -d "$JSON_DATA" \
        "https://api.digitalocean.com/v2/domains/$DO_DOMAIN/records/$DO_RECORD_ID"
    if [ $? -eq 0 ]; then
        echo $IP_ADDRESS > current_ip.txt
    fi
fi
