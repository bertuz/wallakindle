#!/bin/sh

# dump relevant env vars for cron
echo "export KINDLE_EMAIL_ADDRESS=${KINDLE_EMAIL_ADDRESS}" > /etc/cron.d/wallakindle.env
echo "export KINDLE_TAGS_FILTER=${KINDLE_TAGS_FILTER}" >> /etc/cron.d/wallakindle.env
chmod 644 /etc/cron.d/wallakindle.env
# ensure cron job sources the env file
echo "*/30 * * * * root /bin/bash -c 'source /etc/cron.d/wallakindle.env; /home/ubuntu/wallakindle.sh >> /var/log/wallakindle-script.log 2>&1'" > /etc/cron.d/wallakindle
chmod 644 /etc/cron.d/wallakindle
crontab /etc/cron.d/wallakindle
exec cron -f
