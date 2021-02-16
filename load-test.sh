#!/bin/bash 
echo "***************************************"
echo "********* TESIING GO  *****************"
echo "GET http://localhost:9001/debug" | vegeta attack -duration=10s --rate=4  | tee results.bin | vegeta report


echo "***************************************"
echo "********* TESIING GO QUIC *************"
echo "GET http://localhost:9002/debug" | vegeta attack -duration=10s --rate=4  | tee results.bin | vegeta report


echo "***************************************"
echo "********* TESIING NGINX ***************"
echo "GET http://localhost:8181/debug" | vegeta attack -duration=10s --rate=4  | tee results.bin | vegeta report
