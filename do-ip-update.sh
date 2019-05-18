#!/bin/bash

IP_ADDRESS=$(curl -s "https://icanhazip.com")

curl -s -X PUT \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DO_API_KEY" \
    -D '{"data":"$IP_ADDRESS"}' \
    "https://api.digitalocean.com/v2/domains/$DO_DOMAIN/records/$DO_RECORD_ID"


