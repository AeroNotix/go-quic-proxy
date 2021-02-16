FROM golang:1.15 as builder

WORKDIR /app

COPY go.mod go.sum ./

RUN go mod download

COPY . . 

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build

FROM debian:buster

RUN apt-get update && apt-get install -y dumb-init net-tools curl nginx vim nano 

COPY --from=builder /app/go-quic-proxy /usr/bin/go-quic-proxy

COPY docker-deps/run.sh /run.sh
COPY docker-deps/reverse-proxy.conf /etc/nginx/sites-enabled/default
COPY docker-deps/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["/run.sh"]
