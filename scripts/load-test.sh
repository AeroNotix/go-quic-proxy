#!/bin/bash


for loss in $(seq 0 5 25); do

echo "***************************************"
echo "********* TESTING GO GUIC *************"
echo "GET http://localhost:9001/debug" | vegeta attack -duration=10s --rate=4  | vegeta dump -dumper csv | sed "s/$/,$loss/" >> go-quic-test.csv


echo "***************************************"
echo "********* TESTING GO ******************"
echo "GET http://localhost:9002/debug" | vegeta attack -duration=10s --rate=4  | vegeta dump -dumper csv | sed "s/$/,$loss/" >> go-test.csv


echo "***************************************"
echo "********* TESTING NGINX ***************"
echo "GET http://localhost:8181/debug" | vegeta attack -duration=10s --rate=4  | vegeta dump -dumper csv | sed "s/$/,$loss/" >> nginx-test.csv

done
