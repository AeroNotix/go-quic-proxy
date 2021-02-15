package main

import (
	"flag"
	"fmt"
	"log"
	"net/http"
	"net/http/httputil"
	"net/url"

	"github.com/lucas-clemente/quic-go"
	"github.com/lucas-clemente/quic-go/http3"
)

func NewProxy(target *url.URL, useQUIC bool) *httputil.ReverseProxy {
	fmt.Printf("Proxying to %s, QUIC: %t\n", target.Host, useQUIC)

	var qconf quic.Config
	qconf.Versions = []quic.VersionNumber{
		0xff00001d,
	}

	roundTripper := &http3.RoundTripper{
		QuicConfig: &qconf,
	}

	rp := httputil.NewSingleHostReverseProxy(target)

	director := rp.Director
	rp.Director = func(req *http.Request) {
		req.Host = target.Host
		director(req)
	}

	if useQUIC {
		rp.Transport = roundTripper
	}
	return rp
}

func main() {
	var upstream string
	var useQUIC bool
	flag.StringVar(&upstream, "upstream", "", "Upstream server to proxy to")
	flag.BoolVar(&useQUIC, "use-quic", false, "Use QUIC or not when proxying")
	flag.Parse()
	u, err := url.Parse(upstream)
	if err != nil {
		panic(err)
	}
	proxy := NewProxy(u, useQUIC)
	http.HandleFunc("/", proxy.ServeHTTP)
	srv := &http.Server{
		Addr: ":9001",
	}
	if err := srv.ListenAndServe(); err != nil {
		log.Println(err)
	}
}
