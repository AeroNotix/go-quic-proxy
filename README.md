go-quic-proxy
=============


Very simple reverse proxy which can optionally enable using QUIC transport.

```shell
go build main.go

# Without QUIC
./main -upstream https://something.domain.info/debug/

# With QUIC
./main -upstream https://something.domain.info/debug/ -use-quic
```
