#!/bin/bash 


for loss in $(seq 1 3 80); do

echo "***************************************"
echo "********* TESIING GO  *****************"
echo "GET http://localhost:9001/debug" | vegeta attack -duration=10s --rate=4  | vegeta dump -dumper csv  
mv loadtest.csv go-test.csv
sed "s/$/,$loss/" >> go-test.csv


echo "***************************************"
echo "********* TESIING GO QUIC *************"
echo "GET http://localhost:9002/debug" | vegeta attack -duration=10s --rate=4  | tee results.bin | vegeta report


mv loadtest.csv go-quic-test.csv
sed "s/$/,$loss/" >> go-quic-test.csv

echo "***************************************"
echo "********* TESIING NGINX ***************"
echo "GET http://localhost:8181/debug" | vegeta attack -duration=10s --rate=4  | tee results.bin | vegeta report


mv loadtest.csv nginx-test.csv
sed "s/$/,$loss/" >> nginx-test.csv

done
