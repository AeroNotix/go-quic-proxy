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

type QUICRoundTripper struct {
	http3RoundTripper *http3.RoundTripper
	http3RoundTripOpt http3.RoundTripOpt
}

func (qrt QUICRoundTripper) RoundTrip(req *http.Request) (*http.Response, error) {
	return qrt.http3RoundTripper.RoundTripOpt(req, qrt.http3RoundTripOpt)
}

func NewProxy(target *url.URL, useQUIC bool) *httputil.ReverseProxy {
	fmt.Printf("Proxying to %s, QUIC: %t\n", target.Host, useQUIC)

	rp := httputil.NewSingleHostReverseProxy(target)

	director := rp.Director
	rp.Director = func(req *http.Request) {
		director(req)
		req.Host = target.Host
	}

	if useQUIC {
		qconf := quic.Config{
			Versions: []quic.VersionNumber{
				0xff00001d,
			},
			KeepAlive: true,
		}

		roundTripper := &QUICRoundTripper{
			http3RoundTripper: &http3.RoundTripper{
				QuicConfig: &qconf,
			},
			http3RoundTripOpt: http3.RoundTripOpt{},
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
