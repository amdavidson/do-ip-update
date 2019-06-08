#!/bin/sh

PAYLOAD='{"data":"'$(curl -s "https://icanhazip.com/s")'"}'

echo $PAYLOAD

curl -s -X PUT \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $DO_API_KEY" \
    -d $PAYLOAD \
    "https://api.digitalocean.com/v2/domains/$DO_DOMAIN/records/$DO_RECORD_ID"


