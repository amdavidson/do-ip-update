#!/usr/bin/zsh

source $XDG_CONFIG_HOME/do-ip-update/do-ip-update.conf

IP_PATH="$XDG_DATA_HOME/do-ip-update/current_ip.txt"
OLD_IP=$(<$IP_PATH)
#IP_ADDRESS=$(curl -s "https://icanhazip.com")
IP_ADDRESS=$(curl "http://myexternalip.com/raw")
JSON_DATA=$(jq -n \
    --arg ip "$IP_ADDRESS" \
    '{"data":$ip}')


if [[ $IP_ADDRESS =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
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
                --data-urlencode "To=$TWILIO_TO" \
                --data-urlencode "From=$TWILIO_FROM" \
                --data-urlencode "Body=$HOST: $DO_RECORD_ADDRESS address changed to $IP_ADDRESS" \
                -u $TWILIO_KEY
        fi
    else
        echo "IP address unchanged, $OLD_IP"
    fi
else
    echo "IP address check invalid.\n$IP_ADDRESS"
    curl 'https://api.twilio.com/2010-04-01/Accounts/AC067e9cebbcfb3283e230a4539ab2990d/Messages.json' -X POST \
        --data-urlencode "To=$TWILIO_TO" \
        --data-urlencode "From=$TWILIO_FROM" \
        --data-urlencode "Body=$HOST: Bad IP address returned, ${IP_ADDRESS:0:15}" \
        -u $TWILIO_KEY
fi
