#!/bin/bash 
echo "QUIC"
curl -w "@${BASH_SOURCE%/*}/curl-format.txt" -o /dev/null -s "http://localhost:9001/debug"

echo "HTTP" 
curl -w "@${BASH_SOURCE%/*}/curl-format.txt" -o /dev/null -s "http://localhost:9001/debug"
