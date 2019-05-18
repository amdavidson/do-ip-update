# do-ip-update.sh

A simple script that can be run as a `cron` job to keep a Digital Ocean DNS record up to date. 

This is especially useful for rolling a simple dynamic DNS service using the free DNS hosting from DO.

## Running

Run the script as follows

    $ DO_API_KEY="asdfnwvoqwenvw2ef" \
      DO_RECORD_ID="123841209387" \
      DO_DOMAIN="example.com" \
      do-ip-update.sh

You should see a result with a `200 OK` response code and a JSON struct of the record data.


