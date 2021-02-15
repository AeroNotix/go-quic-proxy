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

	rp := httputil.NewSingleHostReverseProxy(target)

	director := rp.Director
	rp.Director = func(req *http.Request) {
		req.Host = target.Host
		director(req)
	}

	if useQUIC {
		var qconf quic.Config
		qconf.Versions = []quic.VersionNumber{
			0xff00001d,
		}

		roundTripper := &http3.RoundTripper{
			QuicConfig: &qconf,
		}
		rp.Transport = roundTripper
	}
	return rp
}

func main() {
	var listenAddr string
	var upstream string
	var useQUIC bool
	flag.BoolVar(&useQUIC, "use-quic", false, "Use QUIC or not when proxying")
	flag.StringVar(&listenAddr, "listen", ":9001", "Local port to listen on, in obnoxious Go syntax e.g. `:9001`")
	flag.StringVar(&upstream, "upstream", "", "Upstream server to proxy to")
	flag.Parse()
	u, err := url.Parse(upstream)
	if err != nil {
		panic(err)
	}
	proxy := NewProxy(u, useQUIC)
	http.HandleFunc("/", proxy.ServeHTTP)
	srv := &http.Server{
		Addr: listenAddr,
	}
	if err := srv.ListenAndServe(); err != nil {
		log.Println(err)
	}
}
