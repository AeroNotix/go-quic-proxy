#!/bin/bash

run_vegeta() {
    echo "GET http://localhost:$1/debug" | vegeta attack -duration=30s --rate=4  -http2=false -keepalive=false | tee "results-${1}.bin" | vegeta report
}

run_vegeta 9001
run_vegeta 9002
run_vegeta 8181
