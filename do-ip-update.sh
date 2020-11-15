#!/usr/bin/zsh

source $XDG_CONFIG_HOME/do-ip-update/do-ip-update.conf

IP_PATH="$XDG_DATA_HOME/do-ip-update/current_ip.txt"
OLD_IP=$(<$IP_PATH)
IP_ADDRESS=$(curl -s "https://icanhazip.com")
JSON_DATA=$(jq -n \
    --arg ip "$IP_ADDRESS" \
    '{"data":$ip}')

if [ "$IP_ADDRESS" != "$OLD_IP" ]; then
    echo "IP address changed to $IP_ADDRESS"
    curl -s -X PUT \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $DO_API_KEY" \
        -d "$JSON_DATA" \
        "https://api.digitalocean.com/v2/domains/$DO_DOMAIN/records/$DO_RECORD_ID"
    echo ""
    if [ $? -eq 0 ]; then
        echo $IP_ADDRESS > $IP_PATH
        curl 'https://api.twilio.com/2010-04-01/Accounts/AC067e9cebbcfb3283e230a4539ab2990d/Messages.json' -X POST \
            --data-urlencode 'To=+14082184455' \
            --data-urlencode 'From=+12065905490' \
            --data-urlencode "Body=$HOST: local.andr3w.net address changed to $IP_ADDRESS" \
            -u $TWILIO_KEY
    fi
else
    echo "IP address unchanged, $OLD_IP"
fi
