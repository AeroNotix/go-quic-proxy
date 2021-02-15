go-quic-proxy
=============


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
```
