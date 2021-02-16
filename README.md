# go-quic-proxy

Very simple reverse proxy which can optionally enable using QUIC
transport. This is not intended to be a fully formed solution. It is
intended to be used in apples-to-apples comparisons for evaluating
QUIC protocol implementations.

```shell
make

# Without QUIC
./main -upstream https://something.domain.info/debug/

# With QUIC
./main -upstream https://something.domain.info/debug/ -use-quic

# Build test dockerfile, run test dockerfile
docker build -t test -f dockerfiles/loader.dockerfile .
docker run
    --rm \
    --name go-quic-load-proxy  \
    --cap-add=NET_ADMIN \
    -p 8181:8181 \
    -p 9001:9001 \
    -p 9002:9002 \
    test \
    HOST_NAME_HERE
```
