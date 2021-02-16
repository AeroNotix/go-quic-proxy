all:
	@CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -tags netgo -ldflags '-w -extldflags "-static"' -o main *.go

docker:
	@docker build -t test -f loader.dockerfile .
