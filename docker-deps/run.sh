#!/usr/bin/dumb-init /bin/bash

echo "Starting load test proxy for ${1}"

go-quic-proxy -use-quic      -upstream "https://${1}/" &

go-quic-proxy -listen=:9002  -upstream "https://${1}/" &


sed -i "s@\$HOST@${1}@g" /etc/nginx/sites-enabled/default

nginx -g 'daemon off;'
