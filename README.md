# do-ip-update.sh

A simple script that can be run as a `cron` job to keep a Digital Ocean DNS record 
up to date with the outside IP address of the machine running the script. 

This is especially useful for rolling a simple dynamic DNS service using the free 
DNS hosting from DO.

## Running directly

Put these lines into `$XDG_CONFIG_HOME/do-ip-update/do-ip-update.conf`:
    DO_API_KEY="asdfnwvoqwenvw2ef" \
    DO_RECORD_ID="123841209387" \
    DO_DOMAIN="example.com"

Create a directory at `$XDG_DATA_HOME/do-ip-update`

Run the script normally.
